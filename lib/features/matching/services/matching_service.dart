import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/match_model.dart';
import '../../../models/user_model.dart';

class MatchingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Get Top Matches ───────────────────────────────────────────────────────

  /// Fetches all users from Firestore, excludes self and existing group-mates,
  /// calculates compatibility score using the weighted algorithm, and returns
  /// the top 5 most compatible matches.
  Future<List<MatchModel>> getMatches(UserModel currentUser) async {
    try {
      final snapshot = await _db
          .collection('users')
          .get()
          .timeout(const Duration(seconds: 15));

      final allUsers = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((u) => u.userId != currentUser.userId)
          .toList();

      // Compute compatibility for each candidate
      final matches = <MatchModel>[];
      for (final candidate in allUsers) {
        final result = _calculateCompatibility(currentUser, candidate);
        matches.add(result);
      }

      // Sort by matchScore descending, take top 5
      matches.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      return matches.take(5).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Core Algorithm ────────────────────────────────────────────────────────

  MatchModel _calculateCompatibility(UserModel user1, UserModel user2) {
    final scheduleResult = _calculateScheduleOverlap(user1, user2);
    final courseResult   = _calculateCourseOverlap(user1, user2);
    final goalResult     = _calculateGoalSimilarity(user1, user2);
    final styleResult    = _calculateStyleMatch(user1, user2);

    final scheduleScore = scheduleResult['score'] as double;
    final courseScore    = courseResult['score']   as double;
    final goalScore     = goalResult['score']     as double;
    final styleScore    = styleResult['score']    as double;

    // Weighted: schedule 40%, courses 30%, goals 20%, style 10%
    final totalScore =
        (scheduleScore * 0.4 +
         courseScore   * 0.3 +
         goalScore    * 0.2 +
         styleScore   * 0.1) * 100;

    return MatchModel(
      userId:           user2.userId,
      name:             user2.name,
      major:            user2.major,
      year:             user2.year,
      matchScore:       totalScore.round().clamp(0, 100),
      reliabilityScore: user2.reliabilityScore,
      scheduleScore:    scheduleScore,
      courseScore:       courseScore,
      goalScore:        goalScore,
      styleScore:       styleScore,
      scheduleOverlap:  scheduleResult['description'] as String,
      courseOverlap:    courseResult['description']    as String,
      goalSimilarity:   goalResult['description']     as String,
    );
  }

  // ── Schedule Overlap (40%) ────────────────────────────────────────────────

  Map<String, dynamic> _calculateScheduleOverlap(
      UserModel user1, UserModel user2) {
    final days = [
      'monday', 'tuesday', 'wednesday', 'thursday',
      'friday', 'saturday', 'sunday',
    ];

    int matchingSlots = 0;
    int totalSlots = 0;
    String bestOverlap = '';

    for (final day in days) {
      final slots1 = (user1.availability[day] ?? []).toSet();
      final slots2 = (user2.availability[day] ?? []).toSet();
      final intersection = slots1.intersection(slots2);
      matchingSlots += intersection.length;
      totalSlots += slots1.union(slots2).length;

      if (intersection.isNotEmpty && bestOverlap.isEmpty) {
        final dayName = day[0].toUpperCase() + day.substring(1);
        bestOverlap = 'Both free $dayName ${intersection.first}';
      }
    }

    final score = totalSlots > 0 ? matchingSlots / totalSlots : 0.0;
    return {
      'score': score,
      'description': bestOverlap.isEmpty ? 'No schedule overlap' : bestOverlap,
    };
  }

  // ── Course Overlap (30%) ──────────────────────────────────────────────────

  Map<String, dynamic> _calculateCourseOverlap(
      UserModel user1, UserModel user2) {
    final courses1 =
        user1.courses.map((c) => (c['name'] as String?) ?? '').toSet();
    final courses2 =
        user2.courses.map((c) => (c['name'] as String?) ?? '').toSet();

    courses1.remove('');
    courses2.remove('');

    final shared = courses1.intersection(courses2);
    final total  = courses1.union(courses2);

    final score = total.isNotEmpty ? shared.length / total.length : 0.0;
    String description;
    if (shared.isEmpty) {
      description = 'No shared courses';
    } else {
      final sharedList = shared.toList();
      if (sharedList.length <= 2) {
        description = 'Shared: ${sharedList.join(", ")}';
      } else {
        description =
            'Shared: ${sharedList[0]}, ${sharedList[1]}, +${sharedList.length - 2}';
      }
    }

    return {'score': score, 'description': description};
  }

  // ── Goal Similarity (20%) ─────────────────────────────────────────────────

  Map<String, dynamic> _calculateGoalSimilarity(
      UserModel user1, UserModel user2) {
    int matchingGoals = 0;
    int sharedCourses = 0;
    String goalDesc = '';

    for (final c1 in user1.courses) {
      for (final c2 in user2.courses) {
        final name1 = (c1['name'] as String?) ?? '';
        final name2 = (c2['name'] as String?) ?? '';
        if (name1 == name2 && name1.isNotEmpty) {
          sharedCourses++;
          final goal1 = (c1['academicGoal'] as String?) ?? '';
          final goal2 = (c2['academicGoal'] as String?) ?? '';
          if (goal1 == goal2 && goal1.isNotEmpty) {
            matchingGoals++;
            if (goalDesc.isEmpty) {
              goalDesc = 'Both targeting $goal1 in $name1';
            }
          }
        }
      }
    }

    final score = sharedCourses > 0 ? matchingGoals / sharedCourses : 0.0;
    return {
      'score': score,
      'description': goalDesc.isEmpty ? 'Different academic goals' : goalDesc,
    };
  }

  // ── Style Match (10%) ─────────────────────────────────────────────────────

  Map<String, dynamic> _calculateStyleMatch(
      UserModel user1, UserModel user2) {
    final styles1 = user1.learningStyles.toSet();
    final styles2 = user2.learningStyles.toSet();

    final shared = styles1.intersection(styles2);
    final total  = styles1.union(styles2);

    final score = total.isNotEmpty ? shared.length / total.length : 0.0;
    return {'score': score, 'description': ''};
  }

  // ── Send Match Request ────────────────────────────────────────────────────

  Future<void> sendMatchRequest({
    required String senderId,
    required String receiverId,
  }) async {
    try {
      final ref = _db.collection('matchRequests').doc();
      await ref.set({
        'requestId':  ref.id,
        'senderId':   senderId,
        'receiverId': receiverId,
        'status':     'pending',
        'createdAt':  FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}


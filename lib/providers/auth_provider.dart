import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(
    const UserModel(
      userId:            'user6731503088',
      name:              'Thaw Zin Myo Aung',
      email:             '6731503088@lamduan.mfu.ac.th',
      major:             'Software Engineering',
      year:              2,
      reliabilityScore:  95,
      sessionsAttended:  19,
      sessionsScheduled: 20,
      groupIds:          ['finals-web', 'calculus-review', 'history-study'],
    ),
  );

  void logout() => state = null;

  void updateUser(UserModel user) => state = user;
}

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>(
  (ref) => AuthNotifier(),
);


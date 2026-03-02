import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// ignore_for_file: prefer_const_constructors
class AuthNotifier extends Notifier<UserModel?> {
  static const _mockUser = UserModel(
    userId:            'user6731503088',
    name:              'Thaw Zin Myo Aung',
    email:             '6731503088@lamduan.mfu.ac.th',
    major:             'Software Engineering',
    year:              2,
    reliabilityScore:  95,
    sessionsAttended:  19,
    sessionsScheduled: 20,
    groupIds:          ['finals-web', 'calculus-review', 'history-study'],
  );

  @override
  UserModel? build() => _mockUser;

  void logout() {
    state = null;
  }

  void updateUser(UserModel user) {
    state = user;
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

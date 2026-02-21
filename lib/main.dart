import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'services/navigation/app_router.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const StudySyncApp());
}

class StudySyncApp extends StatelessWidget {
  const StudySyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // App configuration
      title: 'StudySync',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.light,

      // GoRouter configuration
      routerConfig: AppRouter.router,
    );
  }
}

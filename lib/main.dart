import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'services/navigation/app_router.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: StudySyncApp()));
}

class StudySyncApp extends StatelessWidget {
  const StudySyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => MaterialApp.router(
        // App configuration
        title: 'StudySync',
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.light,

        // GoRouter configuration
        routerConfig: AppRouter.createRouter(ref),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/firebase_options.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:provider/provider.dart';
import 'helpers/routes.dart';
import 'helpers/theme.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: GetMaterialApp(
        title: 'Habit Tracker',
        theme: appTheme,
        home: const AuthWrapper(), // Use AuthWrapper to manage routing based on auth state
        getPages: appRoutes,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<MyAuthProvider>(context);

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is authenticated
          return GetRouterOutlet(
            initialRoute: '/home',
          );
        } else {
          // User is not authenticated
          return GetRouterOutlet(
            initialRoute: '/login',
          );
        }
      },
    );
  }
}

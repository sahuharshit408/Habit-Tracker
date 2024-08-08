import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:habit_tracker/firebase_options.dart';
import 'package:habit_tracker/providers/habit_provider.dart';
import 'package:provider/provider.dart';
import 'helpers/routes.dart';
import 'helpers/theme.dart';
import 'providers/auth_provider.dart';


void main() async{
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
      ],
      child: GetMaterialApp(
        title: 'Habit Tracker',
        theme: appTheme,
        initialRoute: '/',
        getPages: appRoutes,
      ),
    );
  }
}

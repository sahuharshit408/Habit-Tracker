import 'package:get/get.dart';
import 'package:habit_tracker/helpers/wrapper.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/habit_management_screen.dart';
import '../screens/progress_overview_screen.dart';
import '../screens/statistics_screen.dart';

final List<GetPage> appRoutes = [
  GetPage(name: '/', page: () => const Wrapper()),
  GetPage(name: '/login', page: () => const LoginScreen()),
  GetPage(name: '/signup', page: () => const SignupScreen()),
  GetPage(name: '/forgot-password', page: () => const ForgotPasswordScreen()),
  GetPage(name: '/home', page: () => const HomeScreen()),
  GetPage(name: '/habit-management', page: () => const HabitManagementScreen()),
  GetPage(name: '/progress-overview', page: () => const ProgressOverviewScreen()),
  GetPage(name: '/statistics', page: () => const StatisticsScreen()),
];

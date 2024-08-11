import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/screens/habit_management_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'progress_overview_screen.dart';
import 'statistics_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HabitManagementScreen(),
    const ProgressOverviewScreen(),
    const StatisticsScreen(),
  ];

  final List<String> _titles = [
    'Manage Habits',
    'Progress Overview',
    'Statistics',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Center(
          child: Text(
            _titles[_selectedIndex],
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.grey,),
          onPressed: _signOut,
        ),
        actions: [
          Center(
            child: IconButton(
              icon: const Icon(Icons.light_mode , color: Colors.grey,),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300), // Increase the duration for smoother transitions
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Combining fade and slide transitions for smooth effect
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.05), // Slide from slightly below
                  end: Offset.zero, // End at the center
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _pages[_selectedIndex],
        ),
      ),
      backgroundColor: const Color(0xFF2E2E2E),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF2E2E2E),
        color: Colors.black,
        buttonBackgroundColor: Colors.blueAccent,
        height: 60,
        animationDuration: const Duration(milliseconds: 500), // Increase the duration for smoother animation
        animationCurve: Curves.easeInOut, // Add smooth curve to animation
        items: const <Widget>[
          Icon(Icons.checklist_outlined, size: 30, color: Colors.white),
          Icon(Icons.calendar_today_outlined, size: 30, color: Colors.white),
          Icon(Icons.bar_chart, size: 30, color: Colors.white),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

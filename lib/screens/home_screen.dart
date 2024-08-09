import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/screens/habit_management_screen.dart';
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _pages[_selectedIndex],
      ),
      backgroundColor: const Color(0xFF2E2E2E),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_outlined, size: 30),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined, size: 30),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart, size: 30),
              label: 'Stats',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}

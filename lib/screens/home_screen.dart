import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/screens/habit_management_screen.dart';
import 'habit_list_screen.dart';
import 'progress_overview_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        centerTitle: true, // Center the title horizontally
        title: Center(
          child: Text(_titles[_selectedIndex]),
        ),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _signOut,
        ),
        actions: [
          Center(
            child: IconButton(
              icon: const Icon(Icons.light_mode), // Replace with your desired dark mode icon
              onPressed: (){},
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_outlined, size: 28), // Increased icon size
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 26), // Increased icon size
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 28), // Increased icon size
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Adjust type if needed
      ),
    );
  }
}

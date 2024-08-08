import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import 'package:uuid/uuid.dart';

class AddEditHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddEditHabitScreen({super.key, this.habit});

  @override
  _AddEditHabitScreenState createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends State<AddEditHabitScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uuid = const Uuid(); // Uuid instance for generating unique ids

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _titleController.text = widget.habit!.title;
      _descriptionController.text = widget.habit!.description;
    }
  }

  void _saveHabit() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      // Show an error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title and description')),
      );
      return;
    }

    final newHabit = Habit(
      id: widget.habit?.id ?? _uuid.v4(), // Use existing id if editing, otherwise generate a new one
      title: _titleController.text,
      description: _descriptionController.text,
      completedDates: widget.habit?.completedDates ?? [],
    );

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    if (widget.habit == null) {
      habitProvider.addHabit(newHabit); // Add habit if it's a new one
    } else {
      habitProvider.updateHabit(newHabit); // Update habit if editing
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Add Habit' : 'Edit Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveHabit,
              child: Text(widget.habit == null ? 'Add Habit' : 'Save Habit'),
            ),
          ],
        ),
      ),
    );
  }
}

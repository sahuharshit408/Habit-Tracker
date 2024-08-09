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

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _repeatFrequency = 'None';
  String _selectedCategory = 'No category'; // New field for category

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _titleController.text = widget.habit!.title;
      _descriptionController.text = widget.habit!.description;
      _selectedDate = widget.habit!.scheduledDate;
      _selectedTime = widget.habit!.reminderTime;
      _repeatFrequency = widget.habit!.repeatFrequency;
      _selectedCategory = widget.habit!.category;
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
      scheduledDate: _selectedDate,
      reminderTime: _selectedTime,
      repeatFrequency: _repeatFrequency,
      category: _selectedCategory, // Include the selected category
    );

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    if (widget.habit == null) {
      habitProvider.addHabit(newHabit); // Add habit if it's a new one
    } else {
      habitProvider.updateHabit(newHabit); // Update habit if editing
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
    //Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
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
            ListTile(
              title: Text(
                _selectedDate == null
                    ? 'No date chosen'
                    : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text(
                _selectedTime == null
                    ? 'No time chosen'
                    : 'Time: ${_selectedTime!.format(context)}',
              ),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            ListTile(
              title: const Text('Repeat'),
              trailing: DropdownButton<String>(
                value: _repeatFrequency,
                onChanged: (String? newValue) {
                  setState(() {
                    _repeatFrequency = newValue!;
                  });
                },
                items: <String>['None', 'Daily', 'Weekly', 'Monthly']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text('Category'),
              trailing: DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: <String>[
                  'Work',
                  'Personal',
                  'Professional',
                  'Others',
                  'No category',
                  'Reminder'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
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

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
  final _uuid = const Uuid();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _repeatFrequency = 'None';
  String _selectedCategory = 'No category';

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title and description')),
      );
      return;
    }

    final newHabit = Habit(
      id: widget.habit?.id ?? _uuid.v4(),
      title: _titleController.text,
      description: _descriptionController.text,
      completedDates: widget.habit?.completedDates ?? [],
      scheduledDate: _selectedDate,
      reminderTime: _selectedTime,
      repeatFrequency: _repeatFrequency,
      category: _selectedCategory,
    );

    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    if (widget.habit == null) {
      habitProvider.addHabit(newHabit);
    } else {
      habitProvider.updateHabit(newHabit);
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
        backgroundColor: Colors.black,
        title: Text(widget.habit == null ? 'Add Habit' : 'Edit Habit' , style: const TextStyle(color: Colors.white),),
      ),
      body: Container(
        color: Colors.grey[900],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ListTile(
              tileColor: Colors.black,
              textColor: Colors.white,
              title: Text(
                _selectedDate == null
                    ? 'No date chosen'
                    :  'Date: ${_formatDate(_selectedDate!)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              tileColor: Colors.black,
              textColor: Colors.white,
              title: Text(
                _selectedTime == null
                    ? 'No time chosen'
                    : 'Time: ${_selectedTime!.format(context)}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context),
            ),
            ListTile(
              tileColor: Colors.black,
              textColor: Colors.white,
              title: const Text('Repeat'),
              trailing: DropdownButton<String>(
                value: _repeatFrequency,
                onChanged: (String? newValue) {
                  setState(() {
                    _repeatFrequency = newValue!;
                  });
                },
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
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
              tileColor: Colors.black,
              textColor: Colors.white,
              title: const Text('Category'),
              trailing: DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
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
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
              ),
              child: Text(widget.habit == null ? 'Add Habit' : 'Save Habit'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formattedDate = "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
    return formattedDate;
  }
}

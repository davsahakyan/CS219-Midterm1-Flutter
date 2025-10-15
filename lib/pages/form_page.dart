import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/homework_bloc.dart';

class AddHomeworkPage extends StatefulWidget {
  const AddHomeworkPage({super.key});

  @override
  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      initialDate: _dueDate ?? now,
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a due date')),
      );
      return;
    }

    context.read<HomeworkBloc>().add(
      AddHomeworkEvent(
        subject: _subjectCtrl.text,
        title: _titleCtrl.text,
        dueDate: _dueDate!,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Homework')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Homework name',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _subjectCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Subject name / code',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.date_range_outlined),
                        label: Text(
                          _dueDate == null
                              ? 'Pick due date'
                              : _formatDate(_dueDate!),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
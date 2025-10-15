import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/homework.dart';
import '../bloc/homework_bloc.dart';

class HomeworkTile extends StatelessWidget {
  const HomeworkTile({super.key, required this.item});
  final Homework item;

  @override
  Widget build(BuildContext context) {
    final style = item.completed
        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
      decoration: TextDecoration.lineThrough,
      color: Theme.of(context).disabledColor,
    )
        : Theme.of(context).textTheme.bodyMedium;

    return Card(
      child: ListTile(
        leading: Checkbox(
          value: item.completed,
          onChanged: (_) => context
              .read<HomeworkBloc>()
              .add(ToggleCompleteEvent(item.id)),
        ),
        title: Text(item.title, style: style),
        subtitle: Text('${item.subject} • due ${_formatDate(item.dueDate)}', style: style),
        trailing: item.completed
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.radio_button_unchecked),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
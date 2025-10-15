import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/homework_bloc.dart';
import '../widgets/homework_tile.dart';

class HomeworkListPage extends StatelessWidget {
  const HomeworkListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming homeworks')),
      body: BlocBuilder<HomeworkBloc, HomeworkState>(
        builder: (context, state) {
          if (state.status == HomeworkStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty) {
            return const _EmptyState();
          }

          // Sort by due date ascending
          final items = List.of(state.items)
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final item = items[index];
              return HomeworkTile(item: item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: const Text(''),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.menu_book_outlined, size: 64),
          const SizedBox(height: 12),
          const Text('No homework yet'),
          const SizedBox(height: 6),
          Text(
            'Tap the Add button to create your first task',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
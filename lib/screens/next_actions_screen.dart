import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import '../widgets/quick_add_task.dart';

class NextActionsScreen extends ConsumerWidget {
  const NextActionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextActionTasks = ref.watch(nextActionTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Actions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Next Actions'),
                  content: const Text(
                    'Next Actionsは、今すぐ取りかかれる具体的な行動のリストです。\n\n'
                    'このリストから、状況に応じて次に実行するタスクを選びます。',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('閉じる'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: nextActionTasks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Next Actionsは空です',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Inboxから実行可能なタスクを移動しましょう',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: nextActionTasks.length,
              itemBuilder: (context, index) {
                final task = nextActionTasks[index];
                return TaskListItem(task: task);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const QuickAddTask(initialStatus: 'nextAction'),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

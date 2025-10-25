import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';

class WaitingScreen extends ConsumerWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waitingTasks = ref.watch(waitingTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting For'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Waiting For'),
                  content: const Text(
                    'Waiting Forは、他の人の行動や特定の出来事を待っているタスクのリストです。\n\n'
                    '定期的に確認し、必要に応じてフォローアップしましょう。',
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
      body: waitingTasks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    '待機中のタスクはありません',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: waitingTasks.length,
              itemBuilder: (context, index) {
                final task = waitingTasks[index];
                return TaskListItem(task: task);
              },
            ),
    );
  }
}

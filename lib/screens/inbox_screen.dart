import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import '../widgets/quick_add_task.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxTasks = ref.watch(inboxTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Inbox'),
                  content: const Text(
                    'Inboxは、思いついたことや受け取ったタスクを一時的に保管する場所です。\n\n'
                    '定期的にInboxを確認し、各タスクを適切なリスト（Next Actions、Projects、Waiting、Someday/Maybe）に振り分けましょう。',
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
      body: inboxTasks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Inboxは空です',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '下のボタンから新しいタスクを追加しましょう',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: inboxTasks.length,
              itemBuilder: (context, index) {
                final task = inboxTasks[index];
                return TaskListItem(task: task);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const QuickAddTask(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

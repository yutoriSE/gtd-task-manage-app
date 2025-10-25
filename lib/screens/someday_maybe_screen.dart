import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';

class SomedayMaybeScreen extends ConsumerWidget {
  const SomedayMaybeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final somedayMaybeTasks = ref.watch(somedayMaybeTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Someday/Maybe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Someday/Maybe'),
                  content: const Text(
                    'Someday/Maybeは、今はやらないけれど、いつかやるかもしれないアイデアや目標のリストです。\n\n'
                    '定期的に見直して、実行すべきものがあればNext Actionsに移動しましょう。',
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
      body: somedayMaybeTasks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Someday/Maybeは空です',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'いつかやりたいアイデアを保存しましょう',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: somedayMaybeTasks.length,
              itemBuilder: (context, index) {
                final task = somedayMaybeTasks[index];
                return TaskListItem(task: task);
              },
            ),
    );
  }
}

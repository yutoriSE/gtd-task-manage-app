import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_list_item.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final projectTasks = tasks.where((task) => task.projectId == widget.project.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: Column(
        children: [
          if (widget.project.description != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.project.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'タスク (${projectTasks.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: projectTasks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'このプロジェクトにタスクはありません',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: projectTasks.length,
                    itemBuilder: (context, index) {
                      final task = projectTasks[index];
                      return TaskListItem(task: task);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新しいタスク'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'タスク名',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final task = Task(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  projectId: widget.project.id,
                  status: TaskStatus.nextAction,
                );
                ref.read(taskProvider.notifier).addTask(task);
                Navigator.pop(context);
              }
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }
}

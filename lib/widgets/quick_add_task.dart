import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class QuickAddTask extends ConsumerStatefulWidget {
  final String? initialStatus;

  const QuickAddTask({super.key, this.initialStatus});

  @override
  ConsumerState<QuickAddTask> createState() => _QuickAddTaskState();
}

class _QuickAddTaskState extends ConsumerState<QuickAddTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority? _selectedPriority;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '新しいタスク',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'タスク名',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: '説明（任意）',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Priority>(
            value: _selectedPriority,
            decoration: const InputDecoration(
              labelText: '優先度',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: Priority.low,
                child: Text('低'),
              ),
              DropdownMenuItem(
                value: Priority.medium,
                child: Text('中'),
              ),
              DropdownMenuItem(
                value: Priority.high,
                child: Text('高'),
              ),
              DropdownMenuItem(
                value: Priority.urgent,
                child: Text('緊急'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedPriority = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _addTask,
                child: const Text('追加'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _addTask() {
    if (_titleController.text.isEmpty) {
      return;
    }

    TaskStatus status = TaskStatus.inbox;
    if (widget.initialStatus == 'nextAction') {
      status = TaskStatus.nextAction;
    }

    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      status: status,
      priority: _selectedPriority,
    );

    ref.read(taskProvider.notifier).addTask(task);
    Navigator.pop(context);
  }
}

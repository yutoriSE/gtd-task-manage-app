import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskDetailDialog extends ConsumerStatefulWidget {
  final Task task;

  const TaskDetailDialog({super.key, required this.task});

  @override
  ConsumerState<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends ConsumerState<TaskDetailDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Priority? _selectedPriority;
  late DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    _selectedPriority = widget.task.priority;
    _dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('タスク詳細'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タスク名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '説明',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                  value: null,
                  child: Text('なし'),
                ),
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
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('期限'),
              subtitle: Text(
                _dueDate != null
                    ? DateFormat('yyyy/MM/dd').format(_dueDate!)
                    : '未設定',
              ),
              trailing: IconButton(
                icon: Icon(_dueDate != null ? Icons.clear : Icons.calendar_today),
                onPressed: () async {
                  if (_dueDate != null) {
                    setState(() {
                      _dueDate = null;
                    });
                  } else {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _dueDate = date;
                      });
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '作成日: ${DateFormat('yyyy/MM/dd HH:mm').format(widget.task.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (widget.task.waitingFor != null) ...[
              const SizedBox(height: 8),
              Text(
                '待機中: ${widget.task.waitingFor}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: _saveTask,
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      return;
    }

    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      priority: _selectedPriority,
      dueDate: _dueDate,
    );

    ref.read(taskProvider.notifier).updateTask(updatedTask);
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_detail_dialog.dart';

class TaskListItem extends ConsumerWidget {
  final Task task;

  const TaskListItem({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.read(taskProvider.notifier);

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _showMoveDialog(context, ref);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.move_to_inbox,
            label: '移動',
          ),
          SlidableAction(
            onPressed: (context) {
              taskNotifier.deleteTask(task.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '削除',
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.status == TaskStatus.completed,
          onChanged: (value) {
            if (value == true) {
              taskNotifier.completeTask(task.id);
            } else {
              taskNotifier.uncompleteTask(task.id);
            }
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: task.description != null
            ? Text(
                task.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: task.priority != null
            ? _buildPriorityIndicator(task.priority!)
            : null,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => TaskDetailDialog(task: task),
          );
        },
      ),
    );
  }

  Widget _buildPriorityIndicator(Priority priority) {
    Color color;
    switch (priority) {
      case Priority.urgent:
        color = Colors.red;
        break;
      case Priority.high:
        color = Colors.orange;
        break;
      case Priority.medium:
        color = Colors.yellow;
        break;
      case Priority.low:
        color = Colors.green;
        break;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showMoveDialog(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.read(taskProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを移動'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text('Inbox'),
              onTap: () {
                taskNotifier.updateTask(task.copyWith(status: TaskStatus.inbox));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Next Actions'),
              onTap: () {
                taskNotifier.moveToNextAction(task.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Waiting For'),
              onTap: () {
                _showWaitingDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text('Someday/Maybe'),
              onTap: () {
                taskNotifier.moveToSomedayMaybe(task.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showWaitingDialog(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.read(taskProvider.notifier);
    final controller = TextEditingController(text: task.waitingFor);

    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('何を待っていますか？'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '例：田中さんからの返信',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              taskNotifier.moveToWaiting(task.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('移動'),
          ),
        ],
      ),
    );
  }
}

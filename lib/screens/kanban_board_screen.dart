import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_detail_dialog.dart';

class KanbanBoardScreen extends ConsumerWidget {
  const KanbanBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(taskProvider);

    // Filter tasks by status (excluding completed and deleted)
    final inboxTasks = allTasks.where((t) => t.status == TaskStatus.inbox).toList();
    final nextActionTasks = allTasks.where((t) => t.status == TaskStatus.nextAction).toList();
    final waitingTasks = allTasks.where((t) => t.status == TaskStatus.waiting).toList();
    final somedayTasks = allTasks.where((t) => t.status == TaskStatus.somedayMaybe).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GTD Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumn(
              context,
              ref,
              'Inbox',
              TaskStatus.inbox,
              inboxTasks,
              Colors.grey,
            ),
            _buildColumn(
              context,
              ref,
              'Next Actions',
              TaskStatus.nextAction,
              nextActionTasks,
              Colors.blue,
            ),
            _buildColumn(
              context,
              ref,
              'Waiting',
              TaskStatus.waiting,
              waitingTasks,
              Colors.orange,
            ),
            _buildColumn(
              context,
              ref,
              'Someday/Maybe',
              TaskStatus.somedayMaybe,
              somedayTasks,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context,
    WidgetRef ref,
    String title,
    TaskStatus status,
    List<Task> tasks,
    Color color,
  ) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Drag target area
          Expanded(
            child: DragTarget<Task>(
              onWillAccept: (task) => task?.status != status,
              onAccept: (task) {
                ref.read(taskProvider.notifier).updateTaskStatus(task.id, status);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty
                        ? color.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                    border: Border.all(
                      color: candidateData.isNotEmpty
                          ? color.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: tasks.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Drop tasks here',
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return _buildTaskCard(context, ref, tasks[index]);
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, Task task) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasChecklist = task.checklist.isNotEmpty;
    final completedItems = task.checklist.where((item) => item.isCompleted).length;
    final totalItems = task.checklist.length;

    return Draggable<Task>(
      data: task,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surfaceVariant.withOpacity(0.3),
                colorScheme.surface,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: _buildTaskCardContent(context, task, hasChecklist, completedItems, totalItems),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildTaskCardContent(context, task, hasChecklist, completedItems, totalItems),
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => _showTaskDetails(context, ref, task),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surfaceVariant.withOpacity(0.1),
                  colorScheme.surface,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildTaskCardContent(context, task, hasChecklist, completedItems, totalItems),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCardContent(BuildContext context, Task task, bool hasChecklist, int completedItems, int totalItems) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    bool isOverdue = false;

    if (task.dueDate != null) {
      final dueDay = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      isOverdue = dueDay.isBefore(today);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (task.priority != null) ...[
              const SizedBox(width: 8),
              _buildPriorityBadge(task.priority!),
            ],
          ],
        ),
        if (task.description != null && task.description!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            task.description!,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            if (task.dueDate != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? Colors.red.withOpacity(0.1)
                      : colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isOverdue ? Colors.red : colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOverdue ? Icons.warning_amber : Icons.calendar_today,
                      size: 12,
                      color: isOverdue ? Colors.red : colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(task.dueDate!),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isOverdue ? Colors.red : colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
            ],
            if (hasChecklist) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.checklist, size: 12, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '$completedItems/$totalItems',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
            ],
            if (task.links.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.link, size: 12, color: Colors.purple),
                    const SizedBox(width: 4),
                    Text(
                      task.links.length.toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (hasChecklist && totalItems > 0) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: completedItems / totalItems,
              minHeight: 6,
              backgroundColor: colorScheme.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ],
        if (task.tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: task.tags.take(3).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildPriorityBadge(Priority priority) {
    Color color;
    String label;

    switch (priority) {
      case Priority.urgent:
        color = Colors.red;
        label = 'Urgent';
        break;
      case Priority.high:
        color = Colors.orange;
        label = 'High';
        break;
      case Priority.medium:
        color = Colors.yellow[700]!;
        label = 'Medium';
        break;
      case Priority.low:
        color = Colors.green;
        label = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.month}/${date.day}';
    }
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'Task title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                ref.read(taskProvider.notifier).createQuickTask(titleController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDetailDialog(task: task),
    );
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.inbox:
        return 'Inbox';
      case TaskStatus.nextAction:
        return 'Next Actions';
      case TaskStatus.waiting:
        return 'Waiting';
      case TaskStatus.somedayMaybe:
        return 'Someday/Maybe';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.deleted:
        return 'Deleted';
    }
  }
}

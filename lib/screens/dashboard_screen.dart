import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/project_provider.dart';
import '../widgets/task_detail_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(taskProvider);
    final activeProjects = ref.watch(activeProjectsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Statistics
    final inboxCount = allTasks.where((t) => t.status == TaskStatus.inbox).length;
    final nextActionCount = allTasks.where((t) => t.status == TaskStatus.nextAction).length;
    final waitingCount = allTasks.where((t) => t.status == TaskStatus.waiting).length;
    final completedCount = allTasks.where((t) => t.status == TaskStatus.completed).length;

    // Today's tasks (due today)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todaysTasks = allTasks.where((t) {
      if (t.dueDate == null) return false;
      final dueDay = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return dueDay == today && t.status != TaskStatus.completed;
    }).toList();

    // Overdue tasks
    final overdueTasks = allTasks.where((t) {
      if (t.dueDate == null) return false;
      final dueDay = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
      return dueDay.isBefore(today) && t.status != TaskStatus.completed;
    }).toList();

    // Urgent tasks
    final urgentTasks = allTasks
        .where((t) => t.priority == Priority.urgent && t.status != TaskStatus.completed)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 180,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'GTD Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.secondaryContainer,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.dashboard_outlined,
                    size: 64,
                    color: colorScheme.primary.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Greeting
                _buildGreetingCard(context, colorScheme),
                const SizedBox(height: 16),

                // Statistics
                Text(
                  '統計',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatisticsGrid(
                  context,
                  colorScheme,
                  inboxCount,
                  nextActionCount,
                  waitingCount,
                  completedCount,
                  activeProjects.length,
                ),
                const SizedBox(height: 24),

                // Overdue tasks
                if (overdueTasks.isNotEmpty) ...[
                  _buildSectionHeader(
                    context,
                    '期限切れ',
                    overdueTasks.length,
                    Icons.warning_amber_rounded,
                    Colors.red,
                  ),
                  const SizedBox(height: 12),
                  ...overdueTasks.map((task) => _buildTaskCard(
                        context,
                        ref,
                        task,
                        colorScheme,
                        isOverdue: true,
                      )),
                  const SizedBox(height: 24),
                ],

                // Today's tasks
                _buildSectionHeader(
                  context,
                  '今日のタスク',
                  todaysTasks.length,
                  Icons.today,
                  colorScheme.primary,
                ),
                const SizedBox(height: 12),
                if (todaysTasks.isEmpty)
                  _buildEmptyState(
                    context,
                    colorScheme,
                    '今日のタスクはありません',
                    Icons.check_circle_outline,
                  )
                else
                  ...todaysTasks.map((task) => _buildTaskCard(
                        context,
                        ref,
                        task,
                        colorScheme,
                      )),
                const SizedBox(height: 24),

                // Urgent tasks
                if (urgentTasks.isNotEmpty) ...[
                  _buildSectionHeader(
                    context,
                    '緊急タスク',
                    urgentTasks.length,
                    Icons.priority_high,
                    Colors.red,
                  ),
                  const SizedBox(height: 12),
                  ...urgentTasks.map((task) => _buildTaskCard(
                        context,
                        ref,
                        task,
                        colorScheme,
                        isUrgent: true,
                      )),
                  const SizedBox(height: 24),
                ],

                // Quick actions
                _buildSectionHeader(
                  context,
                  'クイックアクション',
                  null,
                  Icons.flash_on,
                  colorScheme.tertiary,
                ),
                const SizedBox(height: 12),
                _buildQuickActions(context, colorScheme),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingCard(BuildContext context, ColorScheme colorScheme) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = 'おはようございます';
      icon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = 'こんにちは';
      icon = Icons.wb_cloudy;
    } else {
      greeting = 'こんばんは';
      icon = Icons.nightlight_round;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.tertiaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('yyyy年MM月dd日 (E)', 'ja_JP').format(DateTime.now()),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(
    BuildContext context,
    ColorScheme colorScheme,
    int inboxCount,
    int nextActionCount,
    int waitingCount,
    int completedCount,
    int projectCount,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          'Inbox',
          inboxCount.toString(),
          Icons.inbox,
          Colors.grey,
          colorScheme,
        ),
        _buildStatCard(
          context,
          'Next Actions',
          nextActionCount.toString(),
          Icons.check_circle,
          Colors.blue,
          colorScheme,
        ),
        _buildStatCard(
          context,
          'Waiting',
          waitingCount.toString(),
          Icons.schedule,
          Colors.orange,
          colorScheme,
        ),
        _buildStatCard(
          context,
          'Completed',
          completedCount.toString(),
          Icons.done_all,
          Colors.green,
          colorScheme,
        ),
        _buildStatCard(
          context,
          'Projects',
          projectCount.toString(),
          Icons.folder,
          Colors.purple,
          colorScheme,
        ),
        _buildStatCard(
          context,
          'Total',
          (inboxCount + nextActionCount + waitingCount).toString(),
          Icons.assignment,
          colorScheme.primary,
          colorScheme,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    int? count,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    WidgetRef ref,
    Task task,
    ColorScheme colorScheme, {
    bool isOverdue = false,
    bool isUrgent = false,
  }) {
    Color accentColor = colorScheme.primary;
    if (isOverdue) accentColor = Colors.red;
    if (isUrgent) accentColor = Colors.orange;

    final hasChecklist = task.checklist.isNotEmpty;
    final completedItems = task.checklist.where((item) => item.isCompleted).length;
    final totalItems = task.checklist.length;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accentColor.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => TaskDetailDialog(task: task),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: task.status == TaskStatus.completed,
                    onChanged: (value) {
                      if (value == true) {
                        ref.read(taskProvider.notifier).completeTask(task.id);
                      } else {
                        ref.read(taskProvider.notifier).uncompleteTask(task.id);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  if (task.priority != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority!).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getPriorityLabel(task.priority!),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _getPriorityColor(task.priority!),
                        ),
                      ),
                    ),
                ],
              ),
              if (task.description != null && task.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description!,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  if (task.dueDate != null) ...[
                    Icon(
                      isOverdue ? Icons.warning_amber : Icons.calendar_today,
                      size: 16,
                      color: isOverdue ? Colors.red : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MM/dd').format(task.dueDate!),
                      style: TextStyle(
                        fontSize: 13,
                        color: isOverdue ? Colors.red : colorScheme.onSurfaceVariant,
                        fontWeight: isOverdue ? FontWeight.bold : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (hasChecklist) ...[
                    Icon(Icons.checklist, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '$completedItems/$totalItems',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (task.links.isNotEmpty) ...[
                    Icon(Icons.link, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      task.links.length.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              if (hasChecklist && totalItems > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: completedItems / totalItems,
                    minHeight: 6,
                    backgroundColor: colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    String message,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            context,
            'タスク追加',
            Icons.add_task,
            colorScheme.primary,
            () {
              // Quick add task action
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            context,
            'プロジェクト',
            Icons.create_new_folder,
            colorScheme.secondary,
            () {
              // Add project action
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return Colors.red;
      case Priority.high:
        return Colors.orange;
      case Priority.medium:
        return Colors.yellow[700]!;
      case Priority.low:
        return Colors.green;
    }
  }

  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.urgent:
        return '緊急';
      case Priority.high:
        return '高';
      case Priority.medium:
        return '中';
      case Priority.low:
        return '低';
    }
  }
}

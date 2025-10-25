import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../providers/task_provider.dart';
import 'project_detail_screen.dart';

class ProjectListItem extends ConsumerWidget {
  final Project project;

  const ProjectListItem({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectNotifier = ref.read(projectProvider.notifier);
    final tasks = ref.watch(taskProvider);
    final projectTasks = tasks.where((task) => task.projectId == project.id).toList();

    return Slidable(
      key: ValueKey(project.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              projectNotifier.completeProject(project.id);
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: '完了',
          ),
          SlidableAction(
            onPressed: (context) {
              projectNotifier.deleteProject(project.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '削除',
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.folder),
        title: Text(project.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.description != null)
              Text(
                project.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              '${projectTasks.length} タスク',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailScreen(project: project),
            ),
          );
        },
      ),
    );
  }
}

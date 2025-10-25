import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/project_provider.dart';
import '../widgets/project_list_item.dart';
import '../widgets/add_project_dialog.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProjects = ref.watch(activeProjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Projects'),
                  content: const Text(
                    'Projectsは、2つ以上のアクションが必要な成果のことです。\n\n'
                    '各プロジェクトには、次に取るべきアクションを最低1つ設定しましょう。',
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
      body: activeProjects.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'プロジェクトはありません',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '新しいプロジェクトを作成しましょう',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: activeProjects.length,
              itemBuilder: (context, index) {
                final project = activeProjects[index];
                return ProjectListItem(project: project);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddProjectDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

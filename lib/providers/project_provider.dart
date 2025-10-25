import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../services/storage_service.dart';

class ProjectNotifier extends StateNotifier<List<Project>> {
  ProjectNotifier() : super([]) {
    loadProjects();
  }

  void loadProjects() {
    state = StorageService.getAllProjects();
  }

  Future<void> addProject(Project project) async {
    await StorageService.saveProject(project);
    state = [...state, project];
  }

  Future<void> updateProject(Project project) async {
    await StorageService.saveProject(project);
    state = [
      for (final p in state)
        if (p.id == project.id) project else p,
    ];
  }

  Future<void> deleteProject(String projectId) async {
    await StorageService.deleteProject(projectId);
    state = state.where((project) => project.id != projectId).toList();
  }

  Future<void> createProject(String name, {String? description}) async {
    final project = Project(
      id: const Uuid().v4(),
      name: name,
      description: description,
      status: ProjectStatus.active,
    );
    await addProject(project);
  }

  Future<void> completeProject(String projectId) async {
    final project = state.firstWhere((p) => p.id == projectId);
    await updateProject(project.copyWith(
      status: ProjectStatus.completed,
      completedAt: DateTime.now(),
    ));
  }

  Future<void> archiveProject(String projectId) async {
    final project = state.firstWhere((p) => p.id == projectId);
    await updateProject(project.copyWith(
      status: ProjectStatus.archived,
    ));
  }
}

final projectProvider = StateNotifierProvider<ProjectNotifier, List<Project>>((ref) {
  return ProjectNotifier();
});

// Filtered project providers
final activeProjectsProvider = Provider<List<Project>>((ref) {
  final projects = ref.watch(projectProvider);
  return projects.where((project) => project.status == ProjectStatus.active).toList();
});

final completedProjectsProvider = Provider<List<Project>>((ref) {
  final projects = ref.watch(projectProvider);
  return projects.where((project) => project.status == ProjectStatus.completed).toList();
});

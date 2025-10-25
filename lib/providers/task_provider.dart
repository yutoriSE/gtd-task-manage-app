import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    loadTasks();
  }

  void loadTasks() {
    state = StorageService.getAllTasks();
  }

  Future<void> addTask(Task task) async {
    await StorageService.saveTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(Task task) async {
    await StorageService.saveTask(task);
    state = [
      for (final t in state)
        if (t.id == task.id) task else t,
    ];
  }

  Future<void> deleteTask(String taskId) async {
    await StorageService.deleteTask(taskId);
    state = state.where((task) => task.id != taskId).toList();
  }

  Future<void> createQuickTask(String title) async {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      status: TaskStatus.inbox,
    );
    await addTask(task);
  }

  Future<void> moveToNextAction(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    await updateTask(task.copyWith(
      status: TaskStatus.nextAction,
      isActionable: true,
    ));
  }

  Future<void> moveToWaiting(String taskId, String waitingFor) async {
    final task = state.firstWhere((t) => t.id == taskId);
    await updateTask(task.copyWith(
      status: TaskStatus.waiting,
      waitingFor: waitingFor,
    ));
  }

  Future<void> moveToSomedayMaybe(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    await updateTask(task.copyWith(
      status: TaskStatus.somedayMaybe,
    ));
  }

  Future<void> completeTask(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    await updateTask(task.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    ));
  }

  Future<void> uncompleteTask(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    await updateTask(task.copyWith(
      status: TaskStatus.nextAction,
      completedAt: null,
    ));
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

// Filtered task providers
final inboxTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((task) => task.status == TaskStatus.inbox).toList();
});

final nextActionTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((task) => task.status == TaskStatus.nextAction).toList();
});

final waitingTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((task) => task.status == TaskStatus.waiting).toList();
});

final somedayMaybeTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((task) => task.status == TaskStatus.somedayMaybe).toList();
});

final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((task) => task.status == TaskStatus.completed).toList();
});

import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../models/context.dart';

class StorageService {
  static const String tasksBoxName = 'tasks';
  static const String projectsBoxName = 'projects';
  static const String contextsBoxName = 'contexts';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskStatusAdapter());
    Hive.registerAdapter(PriorityAdapter());
    Hive.registerAdapter(ProjectAdapter());
    Hive.registerAdapter(ProjectStatusAdapter());
    Hive.registerAdapter(GTDContextAdapter());

    // Open boxes
    await Hive.openBox<Task>(tasksBoxName);
    await Hive.openBox<Project>(projectsBoxName);
    await Hive.openBox<GTDContext>(contextsBoxName);
  }

  // Task operations
  static Box<Task> get tasksBox => Hive.box<Task>(tasksBoxName);

  static Future<void> saveTask(Task task) async {
    await tasksBox.put(task.id, task);
  }

  static Future<void> deleteTask(String id) async {
    await tasksBox.delete(id);
  }

  static Task? getTask(String id) {
    return tasksBox.get(id);
  }

  static List<Task> getAllTasks() {
    return tasksBox.values.toList();
  }

  // Project operations
  static Box<Project> get projectsBox => Hive.box<Project>(projectsBoxName);

  static Future<void> saveProject(Project project) async {
    await projectsBox.put(project.id, project);
  }

  static Future<void> deleteProject(String id) async {
    await projectsBox.delete(id);
  }

  static Project? getProject(String id) {
    return projectsBox.get(id);
  }

  static List<Project> getAllProjects() {
    return projectsBox.values.toList();
  }

  // Context operations
  static Box<GTDContext> get contextsBox => Hive.box<GTDContext>(contextsBoxName);

  static Future<void> saveContext(GTDContext context) async {
    await contextsBox.put(context.id, context);
  }

  static Future<void> deleteContext(String id) async {
    await contextsBox.delete(id);
  }

  static GTDContext? getContext(String id) {
    return contextsBox.get(id);
  }

  static List<GTDContext> getAllContexts() {
    return contextsBox.values.toList();
  }

  // Initialize default contexts
  static Future<void> initializeDefaultContexts() async {
    if (contextsBox.isEmpty) {
      final defaultContexts = [
        GTDContext(id: 'home', name: '@Home', icon: '🏠'),
        GTDContext(id: 'work', name: '@Work', icon: '💼'),
        GTDContext(id: 'errands', name: '@Errands', icon: '🚗'),
        GTDContext(id: 'computer', name: '@Computer', icon: '💻'),
        GTDContext(id: 'phone', name: '@Phone', icon: '📱'),
        GTDContext(id: 'anywhere', name: '@Anywhere', icon: '🌍'),
      ];

      for (var context in defaultContexts) {
        await saveContext(context);
      }
    }
  }
}

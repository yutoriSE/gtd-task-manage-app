import 'package:hive/hive.dart';

part 'task.g.dart';

enum TaskStatus {
  inbox,
  nextAction,
  waiting,
  somedayMaybe,
  completed,
  deleted,
}

enum Priority {
  low,
  medium,
  high,
  urgent,
}

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  TaskStatus status;

  @HiveField(4)
  Priority? priority;

  @HiveField(5)
  String? projectId;

  @HiveField(6)
  List<String> contexts;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? dueDate;

  @HiveField(9)
  DateTime? completedAt;

  @HiveField(10)
  bool isActionable;

  @HiveField(11)
  String? waitingFor;

  @HiveField(12)
  List<String> tags;

  @HiveField(13)
  int? estimatedMinutes;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.status = TaskStatus.inbox,
    this.priority,
    this.projectId,
    List<String>? contexts,
    DateTime? createdAt,
    this.dueDate,
    this.completedAt,
    this.isActionable = true,
    this.waitingFor,
    List<String>? tags,
    this.estimatedMinutes,
  })  : contexts = contexts ?? [],
        tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    Priority? priority,
    String? projectId,
    List<String>? contexts,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    bool? isActionable,
    String? waitingFor,
    List<String>? tags,
    int? estimatedMinutes,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      contexts: contexts ?? this.contexts,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      isActionable: isActionable ?? this.isActionable,
      waitingFor: waitingFor ?? this.waitingFor,
      tags: tags ?? this.tags,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.index,
      'priority': priority?.index,
      'projectId': projectId,
      'contexts': contexts,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isActionable': isActionable,
      'waitingFor': waitingFor,
      'tags': tags,
      'estimatedMinutes': estimatedMinutes,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.values[json['status']],
      priority: json['priority'] != null ? Priority.values[json['priority']] : null,
      projectId: json['projectId'],
      contexts: List<String>.from(json['contexts'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      isActionable: json['isActionable'] ?? true,
      waitingFor: json['waitingFor'],
      tags: List<String>.from(json['tags'] ?? []),
      estimatedMinutes: json['estimatedMinutes'],
    );
  }
}

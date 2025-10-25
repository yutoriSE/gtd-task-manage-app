import 'package:hive/hive.dart';

part 'project.g.dart';

enum ProjectStatus {
  active,
  onHold,
  completed,
  archived,
}

@HiveType(typeId: 1)
class Project extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  ProjectStatus status;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? dueDate;

  @HiveField(6)
  DateTime? completedAt;

  @HiveField(7)
  String? color;

  @HiveField(8)
  List<String> tags;

  Project({
    required this.id,
    required this.name,
    this.description,
    this.status = ProjectStatus.active,
    DateTime? createdAt,
    this.dueDate,
    this.completedAt,
    this.color,
    List<String>? tags,
  })  : createdAt = createdAt ?? DateTime.now(),
        tags = tags ?? [];

  Project copyWith({
    String? id,
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    String? color,
    List<String>? tags,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      color: color ?? this.color,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'color': color,
      'tags': tags,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: ProjectStatus.values[json['status']],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      color: json['color'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

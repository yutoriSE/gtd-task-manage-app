import 'package:hive/hive.dart';

part 'context.g.dart';

@HiveType(typeId: 2)
class GTDContext extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? icon;

  @HiveField(3)
  String? color;

  GTDContext({
    required this.id,
    required this.name,
    this.icon,
    this.color,
  });

  GTDContext copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
  }) {
    return GTDContext(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  factory GTDContext.fromJson(Map<String, dynamic> json) {
    return GTDContext(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
    );
  }
}

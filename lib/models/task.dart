import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';


part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final bool isDone;

  @HiveField(3)
  final DateTime? createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  const Task({
    required this.id,
    required this.content,
    this.isDone = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(dynamic json) => Task(
        id: json['id'] as String,
        content: json['content'] as String,
        isDone: json['isDone'] != null ? json['isDone'] as bool : false,
        createdAt: json['createdAt'] is String ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] is String ? DateTime.parse(json['updatedAt']) : null,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['content'] = content;
    map['isDone'] = isDone;
    map['createdAt'] = createdAt?.toUtc().toIso8601String();
    map['updatedAt'] = updatedAt?.toUtc().toIso8601String();
    return map;
  }

  Task copyWith({
    String? content,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, content, isDone, createdAt, updatedAt];
}

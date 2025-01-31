import 'package:hive/hive.dart';

part 'todoapp_model.g.dart';

@HiveType(typeId: 0)
class TodoAppModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  bool isCompelete;
  @HiveField(3)
  DateTime createdAt;

  TodoAppModel({
    required this.title,
    required this.description,
    required this.isCompelete,
    required this.createdAt,
  });
}

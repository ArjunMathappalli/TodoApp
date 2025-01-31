import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/Model/todoapp_model.dart';

class TodoHiveServices {
  Box<TodoAppModel>? _todoBox;

  Future<void> openBox() async {
    _todoBox = await Hive.openBox('todoapp');
  }

  Future<void> closeBox() async {
    await _todoBox?.close();
  }

  Future<void> addTodo(TodoAppModel todoAppModel) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox?.add(todoAppModel);
  }

  Future<List<TodoAppModel>> getAllTodo() async {
    if (_todoBox == null) {
      await openBox();
    }
    return _todoBox!.values.toList();
  }

  Future<void> deleteTodo(int index) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox?.deleteAt(index);
  }

  Future<void> updateTodo(int index, TodoAppModel todoAppModel) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox?.putAt(index, todoAppModel);
  }
}

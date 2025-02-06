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
    List<TodoAppModel> todos = _todoBox!.values.toList();
    todos.insert(0, todoAppModel);
    await _todoBox?.clear();
    await _todoBox?.addAll(todos);
    // await _todoBox?.add(todoAppModel);
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
    if (index >= 0 && index < _todoBox!.length) {
      await _todoBox?.deleteAt(index);
    } else {
      throw Exception('Index out of range');
    }
  }

  Future<void> updateTodo(int index, TodoAppModel todoAppModel) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox?.putAt(index, todoAppModel);
  }
}

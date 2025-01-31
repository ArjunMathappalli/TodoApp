import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_hive/Controller/hive_controller.dart';
import 'package:todo_hive/Model/todoapp_model.dart';
import 'package:todo_hive/View/todo_home_page.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAppModelAdapter());
  await TodoHiveServices().openBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoHomePage(),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:todo_hive/Controller/hive_controller.dart';
import 'package:todo_hive/Model/todoapp_model.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TodoHiveServices _todoHiveServices = TodoHiveServices();
  List<TodoAppModel> _todoLists = [];
  bool? isSelect = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllTodoLists();
  }

  Future<void> loadAllTodoLists() async {
    _todoLists = await _todoHiveServices.getAllTodo();
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _todoHiveServices.closeBox();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmation(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          backgroundColor: Colors.indigo[900],
          centerTitle: true,
          title: const Text(
            "Todos",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.indigo[900],
          onPressed: () {
            _titleController.clear();
            _descriptionController.clear();
            addTodo();
            print("button cliclked");
          },
          label: Text("Add",
              style: TextStyle(color: Colors.indigo[50], fontSize: 18)),
          icon: Icon(Icons.add, color: Colors.indigo[50], size: 28),
        ),
        body: _todoLists.isEmpty
            ? Center(
                child: Text(
                  "No Todos",
                  style: TextStyle(fontSize: 14),
                ),
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.indigo[50],
                child: Column(children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: _todoLists.length,
                        itemBuilder: (context, index) {
                          final todos = _todoLists[index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 1,
                            color: Colors.indigo[50],
                            child: ListTile(
                              leading: Checkbox(
                                  activeColor: Colors.indigo[900],
                                  value: todos.isCompelete,
                                  onChanged: (value) {
                                    setState(() {
                                      todos.isCompelete = value!;
                                    });
                                  }),
                              title: Text(
                                todos.title,
                                style: TextStyle(
                                    color: todos.isCompelete
                                        ? Colors.grey
                                        : Colors.indigo[900],
                                    fontWeight: FontWeight.bold,
                                    decoration: todos.isCompelete
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                              subtitle: Text(todos.description,
                                  style: TextStyle(
                                      color: todos.isCompelete
                                          ? Colors.grey
                                          : Colors.grey[800],
                                      fontWeight: FontWeight.bold,
                                      decoration: todos.isCompelete
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none)),
                              trailing: SizedBox(
                                width: 100,
                                // color: Colors.red[50],
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: Colors.indigo[900]),
                                      onPressed: () {
                                        EditTodo(todos, index);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.red[900]),
                                      onPressed: () async {
                                        print("Delete button clicked");
                                        bool isDeleted =
                                            await showDeleteDialog(index);
                                        if (isDeleted) {
                                          loadAllTodoLists();
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ]),
              ),
      ),
    );
  }

  Future<bool> showDeleteDialog(int index) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.indigo[50],
              title: Center(
                child: Text(
                  "Delete",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900]),
                ),
              ),
              content: Text("Do you really want to delete?"),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.indigo[900]),
                  ),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.indigo[900]),
                  ),
                  child: const Text("Delete",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    await _todoHiveServices.deleteTodo(index);

                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> addTodo() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[50],
          title: Center(
              child: Text(
            "Add Todo",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900]),
          )),
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  // autofocus: true,
                  enableSuggestions: true,
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: "Enter todo title",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TextField(
                    maxLines: 5,
                    // expands: true,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        hintText: "Enter the Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.indigo[900]),
              ),
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.indigo[900]),
              ),
              child: const Text("Add", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All fields are required'),
                      backgroundColor: Colors.indigo[900],
                      elevation: 10,
                    ),
                  );
                  return;
                }
                final newTodo = TodoAppModel(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  isCompelete: false,
                  createdAt: DateTime.now(),
                );
                _todoHiveServices.addTodo(newTodo);
                setState(() {
                  _todoLists.insert(0, newTodo);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully Added'),
                    backgroundColor: Colors.indigo[900],
                    elevation: 10,
                  ),
                );
                _titleController.clear();
                _descriptionController.clear();
                Navigator.pop(context);
                // loadAllTodoLists();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> EditTodo(TodoAppModel todoappmodel, int index) async {
    _titleController.text = todoappmodel.title;
    _descriptionController.text = todoappmodel.description;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[50],
          title: Center(
              child: Text(
            "Edit Todo",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900]),
          )),
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  // autofocus: true,
                  enableSuggestions: true,
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: "Enter todo title",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TextField(
                    maxLines: 5,
                    // expands: true,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        hintText: "Enter the Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.indigo[900]),
              ),
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.indigo[900]),
              ),
              child:
                  const Text("Update", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All fields are required'),
                      backgroundColor: Colors.indigo[900],
                      elevation: 10,
                    ),
                  );
                  return;
                }
                todoappmodel.title = _titleController.text;
                todoappmodel.description = _descriptionController.text;
                todoappmodel.createdAt = DateTime.now();
                if (todoappmodel.isCompelete == true) {
                  todoappmodel.isCompelete = false;
                }

                await _todoHiveServices.updateTodo(index, todoappmodel);
                setState(() {
                  _todoLists[index] = todoappmodel;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully Updated!!!!'),
                    backgroundColor: Colors.indigo[900],
                    elevation: 10,
                  ),
                );
                _titleController.clear();
                _descriptionController.clear();
                Navigator.pop(context);
                // loadAllTodoLists();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirm Exit"),
            content: Text("Do you really want to exit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }
}

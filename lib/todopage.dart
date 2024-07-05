import 'package:flutter/material.dart';
import 'package:to_do_list_app1/add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add To Do'),
        icon: const Icon(Icons.add), // Optional, adds an icon
        backgroundColor: Colors.blue, // Optional, customizes the button color
      ),
    );
  }
  void navigateToAddPage(){
    final route = MaterialPageRoute(
        builder: (context) => AddToDoPage(),
    );
    Navigator.push(context,route);
  }
}

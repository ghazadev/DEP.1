import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_list_app1/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchToDo,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final id = item['_id'];

            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'Edit') {
                    // Implement edit functionality if needed
                  } else if (value == 'Delete') {
                    deleteById(id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text('Edit'),
                    value: 'Edit',
                  ),
                  PopupMenuItem(
                    child: Text('Delete'),
                    value: 'Delete',
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add To Do'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void navigateToAddPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddToDoPage()),
    ).then((_) => fetchToDo()); // Refresh list after adding a new item
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        final filteredItems = items.where((element) => element['_id'] != id).toList();
        setState(() {
          items = filteredItems;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item')),
        );
      }
    } catch (error) {
      print('Error deleting item: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item')),
      );
    }
  }

  Future<void> fetchToDo() async {
    setState(() {
      isLoading = true;
    });

    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final result = jsonData['items'];
        setState(() {
          items = result;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data')),
        );
      }
    } catch (error) {
      print('Error fetching data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

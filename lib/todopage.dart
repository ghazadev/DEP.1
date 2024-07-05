import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_list_app1/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

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
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh:fetchToDo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context , index){
              final item = items[index] as Map;
              final id = item['_id'] as String;
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(
                item['title']
            ),
            subtitle: Text(item['description']),
            trailing: PopupMenuButton(
              onSelected: (value){
                if(value == 'Edit'){

                }else if(value == 'Delete'){
                  deleteById(id);
                }

              },
              itemBuilder: (context){
                return[
                  PopupMenuItem(child: Text('Edit'),
                  value : 'Edit'),
                  PopupMenuItem(child: Text('Delete'),
                    value: 'Delete',
                  ),
                ];
              },

            ),
            );
          },),
        ),
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

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        // Successful deletion
        final filtered = items.where((element) => element['_id'] != id).toList();
        print('Filtered Items: $filtered'); // Check filtered items
        setState(() {
          items = filtered;
        });
        print('Items after deletion: $items'); // Check items after setState
      } else {
        // Handle specific error scenarios if needed
        print('Failed to delete item with id: $id');
        print('HTTP Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        // You might want to handle or show an error message to the user
      }
    } catch (error) {
      // Handle any unexpected errors
      print('Error deleting item: $error');
      // You might want to handle or show an error message to the user
    }
  }



  Future<void> fetchToDo() async {

    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

}
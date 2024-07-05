import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key});

  @override
  State<AddToDoPage> createState() => AddToDoPageState();
}

class AddToDoPageState extends State<AddToDoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Add To Do',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            // Set text color to white
          ),
        ),
      ),


      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white70,fontSize: 30),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white,), // Change underline color here
                ),
              ),
            ),


            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.white70,fontSize: 30),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Change underline color here
                ),

              ),
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 6,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: submitData,
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(20, 50)), // Adjust width and height as needed
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void showSuccessMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      backgroundColor: Colors.green, // Keep the SnackBar background color as it was
      duration: Duration(seconds: 2), // Adjust duration as needed
      behavior: SnackBarBehavior.floating, // Use floating behavior for better visibility
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Optional: Add rounded corners
      ),
      action: SnackBarAction(
        label: 'Close', // Optional: Add a close action
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 201) {
        titleController.text = '';
        descriptionController.text = '';
        print('Creation success');
        showSuccessMessage(context, 'Creation success');
      } else {
        print('Creation failed');
        print(response.body);
        showErrorMessage(context, 'Creation failed: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      showErrorMessage(context, 'Error: $e');
    }
  }
}

void showErrorMessage(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

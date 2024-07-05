import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

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
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(height: 50),

            _buildTextFieldWithShadow(
              icon: Icons.title,
              hintText: 'Title',
              controller: titleController,
            ),
            SizedBox(height: 20),
            _buildTextFieldWithShadow(
              icon: Icons.description,
              hintText: 'Description',
              controller: descriptionController,
              maxLines: 6,
            ),
            SizedBox(height: 40),
            ElevatedButton(

              onPressed: submitData,
              style: ButtonStyle(

                minimumSize: MaterialStateProperty.all(Size(10, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),

              ),
              child: Text(
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

  Widget _buildTextFieldWithShadow({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 50,
            color: Colors.blueAccent,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.indigo),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
      ),
    );
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
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        titleController.text = '';
        descriptionController.text = '';
        showSuccessMessage(context, 'To-Do item added successfully');
      } else {
        showErrorMessage(context, 'Failed to add To-Do item: ${response.body}');
      }
    } catch (e) {
      showErrorMessage(context, 'Error: $e');
    }
  }

  void showSuccessMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
}

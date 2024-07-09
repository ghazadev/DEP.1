import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_helper.dart  ';


class AddToDoPage extends StatefulWidget {
  final Map? todo;

  const AddToDoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddToDoPage> createState() => AddToDoPageState();
}

class AddToDoPageState extends State<AddToDoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      final dueDate = todo['due_date'];
      titleController.text = title;
      descriptionController.text = description;
      dueDateController.text =
      dueDate != null ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(dueDate)) : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          isEdit ? 'Edit To-Do' : 'Add To-Do',
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20),
            _buildTextFieldWithShadow(
              icon: Icons.description,
              hintText: 'Description',
              controller: descriptionController,
              maxLines: 6,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(height: 20),
            _buildDueDateField(),
            SizedBox(height: 40),
            Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: isEdit ? updateData : submitData,
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      isEdit ? 'Update' : 'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
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
        style: TextStyle(
          color: Colors.black87,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
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

  Widget _buildDueDateField() {
    return GestureDetector(
      onTap: () async {
        final initialDate = dueDateController.text.isNotEmpty
            ? DateTime.parse(dueDateController.text)
            : DateTime.now();

        final selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (selectedDate != null) {
          final selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(initialDate),
          );

          if (selectedTime != null) {
            final selectedDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            setState(() {
              dueDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);
            });
          }
        }
      },
      child: AbsorbPointer(
        child: Container(
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
            controller: dueDateController,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today, color: Colors.indigo),
              hintText: 'Due Date',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You cannot call updateData without todo data');
      return;
    }
    final id = todo['_id'];

    final title = titleController.text;
    final description = descriptionController.text;
    final dueDate = dueDateController.text;

    final body = {
      "title": title,
      "description": description,
      "due_date": dueDate,
      "is_completed": false,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      showSuccessMessage(context, 'To-Do item updated successfully');

      // Schedule notification if due date is provided
      if (dueDate.isNotEmpty) {
        // Parse the due date string to DateTime
        final dueDateTime = DateTime.parse(dueDate);

        // Schedule notification using NotificationHelper
        NotificationHelper.scheduleNotification(title, 'Reminder: $title', dueDateTime);
      }
    } else {
      showErrorMessage(context, 'Update Failed: ${response.body}');
    }
  }


  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final dueDate = dueDateController.text;

    final body = {
      "title": title,
      "description": description,
      "due_date": dueDate,
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
        dueDateController.text = '';
        showSuccessMessage(context, 'To-Do item added successfully');

        // Schedule notification if due date is provided
        if (dueDate.isNotEmpty) {
          // Parse the due date string to DateTime
          final dueDateTime = DateTime.parse(dueDate);

          // Schedule notification using NotificationHelper
          NotificationHelper.scheduleNotification(title, 'Reminder: $title', dueDateTime);
        }
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

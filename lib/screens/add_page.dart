import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  // fetch the text
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add ToDo"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              submitData();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  //! SUBMIT DATA
  Future<void> submitData() async {
    // Get the data from form

    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // Submit data to the server

    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers:  {'Content-Type': 'application/json'}
    );

    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      log('Creation Success');
      showSuccessMessage('Creation Success');
    } else {
      showErrorMessage('Creation Failure');
      log(response.body);
    }
    // Show success or fail msg based on status
  }

  //SnacBar -> Success
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //! SnacBar -> Failure
  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

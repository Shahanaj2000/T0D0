import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todorest/services/todo_services.dart';
import 'package:todorest/utils/snacBarHelper.dart';

class AddToDo extends StatefulWidget {
  final Map? todo;
  const AddToDo({super.key, this.todo});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  // fetch the text
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (widget.todo != null) {
      isEdit = true;
      // prefilling the value -> EDIT popupMenu
      final title = todo!['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit ? 'Edit ToDo' : "Add ToDo",
        ),
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
              isEdit ? updateData() : submitData();
            },
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                isEdit ? 'Update' : "Submit",
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! SUBMIT DATA
  Future<void> submitData() async {
    // Get the data from form

    

    // Submit data to the server

    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      log('Creation Success');
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Creation Failure');
      
    }
    // Show success or fail msg based on status
  }

  //! UPDATE DATA
  Future<void> updateData() async {
   

    final todo = widget.todo;
    if (todo == null) {
      print('You can not call uodated with todo data');
      return;
    }

    final id = todo['_id'];

    

    // Submit update data to the server

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final isSuccess = await TodoService.updateTodo(id, body);

    // Show success or fail msg based on status
    if (isSuccess) {
      
      showSuccessMessage(context, message: 'Upadation Success');
    } else {
      showErrorMessage(context, message: 'Updation Failure');
      
    }
  }



   // Get the data from FORM
  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;

    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }

}

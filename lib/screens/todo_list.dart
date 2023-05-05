import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todorest/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todorest/services/todo_services.dart';
import 'package:todorest/utils/snacBarHelper.dart';

class ToDOListPage extends StatefulWidget {
  const ToDOListPage({super.key});

  @override
  State<ToDOListPage> createState() => _ToDOListPageState();
}

class _ToDOListPageState extends State<ToDOListPage> {
  bool isLoading = true;
  List items = [];
  //...
  @override
  void initState() {
    super.initState();
    fetchToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToAddPage();
        },
        label: const Text("Add Todo"),
      ),
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchToDo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center( 
              child: Text(
                'No ToDo Items',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          // Open edit page
                          navigateToEditPage(item);
                        } else if (value == 'delete') {
                          // Delete and remove the item
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            child: Text("Edit"),
                            value: 'edit',
                          ),
                          const PopupMenuItem(
                            child: Text("Delete"),
                            value: 'delete',
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  //Navigate to addPage
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddToDo(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  //Navigate to editPage
  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDo(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  //! DELETE
  Future<void> deleteById(String id) async {
    // Delete the item
    final isSuccess = await TodoService.deleteById(id);

    if (isSuccess) {
      // Remove the item from List
      final filtered = items.where((element) => element['_id'] != id).toList();

      setState(() {
        items = filtered;
      });
    } else {
      // Show error
      showErrorMessage(context, message: 'Delete Failure');
    }
  }

  //! GET
  Future<void> fetchToDo() async {
    final response = await TodoService.fetchToDo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'Some thing went wrong!');
    }

    setState(() {
      isLoading = false;
    });
  }
}

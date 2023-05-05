import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todorest/screens/add_page.dart';
import 'package:http/http.dart' as http;

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
          child: ListView.separated(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return ListTile(
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
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1.2,
              );
            },
          ),
        ),
      ),
    );
  }

  //Navigate to addPage
  Future<void> navigateToAddPage() async{
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
  Future <void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(
      builder: (context) =>  AddToDo(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  //..
  Future <void> deleteById(String id) async {
    // Delete the item

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
       
       // Remove the item from List
       final filtered = items.where((element) => element['_id'] != id).toList();

       setState(() {
         items = filtered;
       });


    } else {


      // Show error
      showErrorMessage('Delete Failed!');
    }



   
  }

  //! GET -> API
  Future<void> fetchToDo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);

    final response = await http.get(uri);
    // print(response.statusCode);
    // print(response.body);

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

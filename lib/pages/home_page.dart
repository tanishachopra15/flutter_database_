import 'package:FLUTTER_DATABASE_/Widgets/confirmation_dialog.dart';
import 'package:FLUTTER_DATABASE_/pages/todo_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> todos = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final todoCollectionRef = FirebaseFirestore.instance.collection('todos');
  final user = FirebaseAuth.instance.currentUser;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> createTodo({
    required String title,
    required String description,
  }) async {
    try {
      await todoCollectionRef.add({
        'title': title,
        'description': description,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'authorId': user?.uid
      });
    } catch (e) {
      print('error $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final docsRef = await todoCollectionRef
        .where('authorId', isEqualTo: user?.uid.toString())
        .get();
    return docsRef.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  Future<Map<String, dynamic>?> getTodo(String id) async {
    final docsRef = await todoCollectionRef.doc(id).get();
    return docsRef.data();
  }

  Future<void> updateTodo(String id,
      {String? title, String? description}) async {
    await todoCollectionRef.doc(id).update({
      if (title != null) 'title': title,
      if (description != null) 'description': description,
    });
  }

  Future<void> deleteTodo(String id) async {
    await todoCollectionRef.doc(id).delete();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    todos = await getTodos();
    setState(() {
      isLoading = false;
    });
  }

  void todoBox({String? id}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter Todo'),
                  controller: titleController,
                ),
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter description'),
                  controller: descriptionController,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    toggleLoading();
                    if (id == null) {
                      await createTodo(
                          title: titleController.text,
                          description: descriptionController.text);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => const ConfirmationBox(
                                actions: 'Update',
                              ));
                      updateTodo(id,
                          title: titleController.text,
                          description: descriptionController.text);
                    }
                    getData();
                    titleController.clear();
                    descriptionController.clear();
                  },
                  child: Text('${id == null ? 'Add' : 'Update'} Todo'))
            ],
          );
        }).whenComplete(() {
      titleController.clear();
      descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Todo',
            style: TextStyle(color: Colors.amber),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                        title: Text(todo['title']),
                        subtitle: Text(todo['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  titleController.text = todo['title'];
                                  descriptionController.text =
                                      todo['description'];
                                  todoBox(id: todo['id']);
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => const ConfirmationBox(
                                    actions: 'Delete',
                                  ),
                                ).then((value) async {
                                  print(value);
                                  if (value == true) {
                                    toggleLoading();
                                    await deleteTodo(todo['id']);
                                    getData();
                                  }
                                });
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TodoViewer(
                                        todo: todo,
                                        onDelete: (id) async {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const ConfirmationBox(
                                              actions: 'Delete',
                                            ),
                                          ).then((value) async {
                                            print(value);
                                            if (value == true) {
                                              toggleLoading();
                                              await deleteTodo(todo['id']);
                                              getData();
                                            }
                                          });
                                        },
                                      )));
                        });
                  }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: todoBox,
          child: const Icon(
            Icons.add,
          ),
        ));
  }
}

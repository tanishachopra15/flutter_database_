import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final Todo todo = Todo();

  void todoBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'Todo Title'),
                    controller: textController,
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(hintText: 'Todo description'),
                    controller: descController,
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        todo.addTodo(textController.text, descController.text);
                      } else {
                        todo.editTodo(
                            docId!, textController.text, descController.text);
                      }
                      textController.clear();
                      descController.clear();

                      Navigator.pop(context);
                    },
                    child: const Text('Add'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Todo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: todoBox,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: todo.getTodoStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List todoList = snapshot.data!.docs;
              // print(todoList);
              return ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = todoList[index];
                    String docId = document.id;

                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    // print(data);
                    String todoText = data['title'];
                    String descText = data['description'];

                    return ListTile(
                      title: Text(todoText),
                      subtitle: Text(descText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => todoBox(docId: docId),
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () => todo.deleteTodo(docId),
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    );
                  });
            } else {
              return const Text('No todos...');
            }
          },
        ),
      ),
    );
  }
}

class Todo {
  CollectionReference todo = FirebaseFirestore.instance.collection('todos');

  Future<void> addTodo(String text, String description) {
    return todo
        .add({
          'title': text,
          'description': description,
          'created_at': Timestamp.now()
        })
        .then((value) => print('User added'))
        .catchError((e) => print('error :$e'));
  }

  Future<void> editTodo(String docId, String newTodo, String newDesc) {
    return todo.doc(docId).update({
      'title': newTodo,
      'description': newDesc,
      'created_at': Timestamp.now()
    });
  }

  Future<void> deleteTodo(String docId) {
    return todo.doc(docId).delete();
  }

  Stream<QuerySnapshot> getTodoStream() {
    final todoStream = todo.orderBy('title', descending: false).snapshots();

    return todoStream;
  }
}

import 'package:FLUTTER_DATABASE_/Widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

enum Mode { Add, Edit, View }

class TodoMode extends StatefulWidget {
  TodoMode(
      {super.key,
      required this.mode,
      this.title,
      this.description,
      required this.onAction});

  Mode mode;
  final Function onAction;
  final String? title;
  final String? description;

  @override
  State<TodoMode> createState() => _TodoModeState();
}

class _TodoModeState extends State<TodoMode> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mode.name} Todo'),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.mode == Mode.Add) {
                widget.onAction(
                    titleController.text, descriptionController.text);
                return Navigator.pop(context);
              } else if (widget.mode == Mode.Edit) {
                showDialog(
                    context: context,
                    builder: (context) => const ConfirmationBox(
                          actions: 'Update',
                        )).then((value) {
                  if (value == true) {
                    widget.onAction(
                        titleController.text, descriptionController.text);
                    Navigator.pop(context);
                  }
                });
              } else if (widget.mode == Mode.View) {
                setState(() {
                  widget.mode = Mode.Edit;
                });
                print('${widget.mode}');
              }
            },
            icon: widget.mode == Mode.View
                ? const Icon(Icons.edit)
                : const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: widget.mode == Mode.View
            ? Column(
                children: [
                  Text('${widget.title}'),
                  Text('${widget.description}')
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your Title',
                      border: OutlineInputBorder(),
                    ),
                    controller: titleController =
                        TextEditingController(text: widget.title),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    controller: descriptionController =
                        TextEditingController(text: widget.description),
                  )
                ],
              ),
      ),
    );
  }
}

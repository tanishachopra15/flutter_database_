import 'package:flutter/material.dart';

class ConfirmationBox extends StatelessWidget {
  final String actions;
  const ConfirmationBox({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
          content: Text(
            'Do you want to $actions ?',
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Yes',
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No', style: TextStyle(fontSize: 15)),
            ),
          ]),
    );
  }
}

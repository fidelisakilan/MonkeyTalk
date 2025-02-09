import 'package:flutter/material.dart';

Future<String?> showTextInputDialog(BuildContext context) async {
  final TextEditingController textController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter URL'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(textController.text);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

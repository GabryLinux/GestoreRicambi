import 'package:flutter/material.dart';

class ErrorMSG extends StatelessWidget {
  const ErrorMSG({super.key, required this.msg});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Errore"),
      content: Text(msg),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Chiudi'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

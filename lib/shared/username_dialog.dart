// lib/widgets/username_dialog.dart
import 'package:flutter/material.dart';

class UsernameDialog extends StatelessWidget {
  final TextEditingController controller;

  const UsernameDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: const Text('What\'s your Instagram handle?')),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Enter a username'),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
          child: Center(child: const Text('Submit')),
        ),
      ],
    );
  }
}

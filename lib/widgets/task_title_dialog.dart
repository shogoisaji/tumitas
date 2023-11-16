import 'package:flutter/material.dart';

class TaskTitleDialog extends StatelessWidget {
  final TextEditingController _textController;
  final Function(String) onSubmitted;
  const TaskTitleDialog(this._textController,
      {Key? key, required this.onSubmitted})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.note_alt_outlined,
        size: 28,
      ),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: const Color.fromARGB(255, 206, 206, 206),
      content: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
        child: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Task',
          ),
          maxLines: 2,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: Colors.white,
          ),
          child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
        ),
        ElevatedButton(
          onPressed: () {
            onSubmitted(_textController.text);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            backgroundColor: Colors.orange,
          ),
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

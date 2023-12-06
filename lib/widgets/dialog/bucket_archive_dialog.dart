import 'package:flutter/material.dart';
import 'package:tumitas/theme/theme.dart';

class BucketArchiveDialog extends StatefulWidget {
  final Function(bool) addArchive;

  const BucketArchiveDialog({Key? key, required this.addArchive}) : super(key: key);

  @override
  State<BucketArchiveDialog> createState() => _BucketArchiveDialogState();
}

class _BucketArchiveDialogState extends State<BucketArchiveDialog> {
  final Color contentFillColor = MyTheme.grey2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text('Add Archive', style: TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 28)),
      backgroundColor: MyTheme.green5,
      content: const Text(
        'Add this bucket to archive?',
        style: TextStyle(color: MyTheme.grey1, fontSize: 20),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: Colors.white,
          ),
          child: const Text('Cancel', style: TextStyle(color: MyTheme.green1, fontSize: 22)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.addArchive(true);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: MyTheme.green1,
          ),
          child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        ),
      ],
    );
  }
}

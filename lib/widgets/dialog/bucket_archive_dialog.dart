import 'package:flutter/material.dart';
import 'package:tumitas/theme/theme.dart';

class BucketArchiveDialog extends StatefulWidget {
  final Function(bool) addArchive;

  const BucketArchiveDialog({Key? key, required this.addArchive}) : super(key: key);

  @override
  State<BucketArchiveDialog> createState() => _BucketArchiveDialogState();
}

class _BucketArchiveDialogState extends State<BucketArchiveDialog> {
  final Color contentFillColor = MyTheme.grey3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text('Add Archive', style: TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 32)),
      backgroundColor: MyTheme.green5,
      content: const Text(
        'このバケットをアーカイブに追加しますか?',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(left: 8, right: 8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: Colors.white,
          ),
          child: const Text('Cancel', style: TextStyle(color: MyTheme.green1)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.addArchive(true);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(left: 8, right: 8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: MyTheme.green1,
          ),
          child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ),
      ],
    );
  }
}

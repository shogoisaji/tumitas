import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/theme/theme.dart';

class BlockDetailDialog extends StatefulWidget {
  final Block block;

  const BlockDetailDialog({Key? key, required this.block}) : super(key: key);

  @override
  State<BlockDetailDialog> createState() => _BlockDetailDialogState();
}

class _BlockDetailDialogState extends State<BlockDetailDialog> {
  final Color contentFillColor = MyTheme.grey2;

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final oneBlockSize = MediaQuery.of(context).size.width / 5;

    return AlertDialog(
      // title: Text(widget.block.title,
      //     style: const TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 28)),
      backgroundColor: MyTheme.grey2,
      title: Center(
        child: Text(widget.block.title,
            style: const TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 28)),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 4.5 / 5,
        height: widget.block.blockType.blockSize.y * oneBlockSize + 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: widget.block.blockType.blockSize.x * oneBlockSize,
              height: widget.block.blockType.blockSize.y * oneBlockSize,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: widget.block.color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 1.0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Center(
                child: Text('${widget.block.blockType.blockSize.x}x${widget.block.blockType.blockSize.y}',
                    style: TextStyle(
                        color: widget.block.color == MyTheme.lemonYellow ? Colors.grey : Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Text(
              DateFormat('yyyy.MM.dd HH:mm').format(widget.block.blockRegisterDate),
              style: const TextStyle(color: MyTheme.grey1, fontSize: 24),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: MyTheme.green1,
          ),
          child: const Text('Back', style: TextStyle(color: Colors.white, fontSize: 22)),
        ),
      ],
    );
  }
}

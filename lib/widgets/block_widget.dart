import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';

class BlockWidget extends StatelessWidget {
  final Block block;
  final String taskTitle;
  final double titleFontSize = 12;
  const BlockWidget(this.block, {super.key, required this.taskTitle});

  @override
  Widget build(BuildContext context) {
    int titleMaxLine() {
      return block.blockSize.y * 2;
    }

    return Container(
      color: Colors.red[200],
      child: Container(
          width: block.blockSize.x * oneBlockSize,
          height: block.blockSize.y * oneBlockSize,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: block.color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text(
            taskTitle,
            style: TextStyle(
              fontSize: titleFontSize,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: titleMaxLine(),
          ))),
    );
  }
}

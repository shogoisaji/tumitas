import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';

class BlockWidget extends StatelessWidget {
  final Block block;
  final double titleFontSize = 12;
  const BlockWidget(
    this.block, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int titleMaxLine() {
      return block.blockSize.y * 2;
    }

    return Container(
        width: block.blockSize.x * oneBlockSize,
        height: block.blockSize.y * oneBlockSize,
        padding: const EdgeInsets.all(1.5),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: block.color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                spreadRadius: 0.5,
                blurRadius: 2,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Center(
              child: Text(
            block.title,
            style: TextStyle(
              fontSize: titleFontSize,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: titleMaxLine(),
          )),
        ));
  }
}

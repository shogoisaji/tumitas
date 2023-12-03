import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';

class BlockWidget extends StatelessWidget {
  final Block block;
  final double titleFontSize = 14;
  final double oneBlockSize;
  const BlockWidget(
    this.block,
    this.oneBlockSize, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = oneBlockSize / 7;

    return Container(
        width: block.blockType.blockSize.x * oneBlockSize,
        height: block.blockType.blockSize.y * oneBlockSize,
        padding: const EdgeInsets.all(2.0),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: block.color,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                spreadRadius: 0.5,
                blurRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: oneBlockSize > 30
              ? Center(
                  child: Text(
                  block.title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: block.blockType.blockSize.y * 2,
                ))
              : Container(),
        ));
  }
}

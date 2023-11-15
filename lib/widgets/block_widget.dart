import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';

class BlockWidget extends StatelessWidget {
  final Block block;
  const BlockWidget(this.block, {super.key});

  @override
  Widget build(BuildContext context) {
    String getBlockName() {
      return '${block.blockSize.x.toString()}x${block.blockSize.x.toString()}';
    }

    return Container(
      color: Colors.red[200],
      child: Container(
          width: block.blockSize.x * oneBlockSize,
          height: block.blockSize.y * oneBlockSize,
          decoration: BoxDecoration(
            color: block.color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(getBlockName()))),
    );
  }
}

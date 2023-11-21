import 'package:flutter/material.dart';

class Block {
  final Color color;
  final String title;
  final String description;
  final BlockSize blockSize;
  final BlockType blockType;
  Block(this.color, this.blockSize, this.blockType,
      {this.title = '', this.description = ''});
}

class BlockSize {
  final int x;
  final int y;
  BlockSize(this.x, this.y);
}

enum BlockType {
  block1x1,
  block2x1,
  block2x2,
  block3x1,
  block3x2;

  Block get block {
    switch (this) {
      case BlockType.block1x1:
        return Block(Colors.red, BlockSize(1, 1), BlockType.block1x1);
      case BlockType.block2x1:
        return Block(Colors.blue, BlockSize(2, 1), BlockType.block2x1);
      case BlockType.block2x2:
        return Block(Colors.green, BlockSize(2, 2), BlockType.block2x2);
      case BlockType.block3x1:
        return Block(Colors.yellow, BlockSize(3, 1), BlockType.block3x1);
      case BlockType.block3x2:
        return Block(Colors.purple, BlockSize(3, 2), BlockType.block3x2);
      default:
        return Block(Colors.grey, BlockSize(1, 1), BlockType.block1x1);
    }
  }
}

import 'package:flutter/material.dart';

class Block {
  final Color color;
  final String title;
  final String description;
  final BlockSize blockSize;
  // final BlockType blockType;
  Block(this.color, this.blockSize,
      //  this.blockType,

      {this.title = '',
      this.description = ''});
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

  BlockSize get blockSize {
    switch (this) {
      case BlockType.block1x1:
        return BlockSize(1, 1);
      case BlockType.block2x1:
        return BlockSize(2, 1);
      case BlockType.block2x2:
        return BlockSize(2, 2);
      case BlockType.block3x1:
        return BlockSize(3, 1);
      case BlockType.block3x2:
        return BlockSize(3, 2);
      default:
        return BlockSize(1, 1);
    }
  }
}

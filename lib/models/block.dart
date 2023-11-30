import 'package:flutter/material.dart';

class Block {
  final Color color;
  final String title;
  final String description;
  final BlockType blockType;

  Block(
    this.color,
    this.title,
    this.description,
    this.blockType,
  );

  Map<String, dynamic> blockToJson() => {
        'color': color.value,
        'title': title,
        'description': description,
        'blockType': blockType.toString().split('.').last, // toString()->"BlockType.block1x1"
      };

  factory Block.blockFromJson(Map<String, dynamic> json) {
    return Block(
      Color(json['color']),
      json['title'],
      json['description'],
      BlockType.values.firstWhere((e) => e.toString().split('.').last == json['blockType']),
    );
  }
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

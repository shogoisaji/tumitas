import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';

class Bucket {
  final Color bucketInnerColor;
  final Color bucketOuterColor;
  final BucketSizeCells bucketSizeCells;
  final String bucketTitle;
  final List<Map<String, dynamic>> bucketIntoBlock; // [{ 'block': Block, 'position': Position },...]
  final List<int> bucketMaxPosition;

  Bucket({
    required this.bucketTitle,
    required this.bucketInnerColor,
    required this.bucketOuterColor,
    required this.bucketSizeCells,
    required this.bucketIntoBlock,
    required this.bucketMaxPosition,
  });

// // moc
//   final List<Map<String, dynamic>> mocBucketIntoBlock = [
//     {'block': Block(Colors.red, BlockType.block1x1, 'sample1', 'description'), 'position': Position(0, 0)},
//     {'block': Block(Colors.blue, BlockType.block2x1, 'sample2', 'description'), 'position': Position(1, 1)},
//     {'block': Block(Colors.green, BlockType.block2x2, 'sample3', 'description'), 'position': Position(2, 2)},
//     {'block': Block(Colors.orange, BlockType.block2x2, 'sample4', 'description'), 'position': Position(0, 2)},
//     {'block': Block(Colors.grey, BlockType.block2x1, 'sample5', 'description'), 'position': Position(3, 4)},
//     {'block': Block(Colors.teal, BlockType.block1x1, 'sample6', 'description'), 'position': Position(4, 0)},
//     {'block': Block(Colors.black26, BlockType.block2x1, 'sample7', 'description'), 'position': Position(2, 0)},
//   ];

  List<Position> fragmentBlockPosition(Block block, Position position) {
    List<Position> dismantlePosition = [];
    block.blockType.blockSize.x;
    block.blockType.blockSize.y;
    for (int i = 0; i < block.blockType.blockSize.x; i++) {
      for (int j = 0; j < block.blockType.blockSize.y; j++) {
        dismantlePosition.add(Position(position.positionX + i, position.positionY + j));
      }
    }
    return dismantlePosition;
  }

  int getMaxPositionY(Block block, int selectPositionX) {
    List<Position> existPosition = [];
    int maxPositionY = -1;

    for (int i = 0; i < bucketIntoBlock.length; i++) {
      existPosition.addAll(fragmentBlockPosition(bucketIntoBlock[i]['block'], bucketIntoBlock[i]['position']));
    }
    for (int w = 0; w < block.blockType.blockSize.x; w++) {
      for (int l = 0; l < existPosition.length; l++) {
        if (existPosition[l].positionX == selectPositionX + w && existPosition[l].positionY > maxPositionY) {
          maxPositionY = existPosition[l].positionY;
        }
      }
    }
    return maxPositionY;
  }

  bool addNewBlock(Block newBlock, int newPositionX) {
    final maxPositionY = getMaxPositionY(newBlock, newPositionX);
    if (maxPositionY + newBlock.blockType.blockSize.y > bucketSizeCells.y - 1) {
      return false;
    }
    final newPosition = Position(newPositionX, maxPositionY + 1);

    bucketIntoBlock.add({'block': newBlock, 'position': newPosition});
    return true;
  }
}

class Position {
  // (0,0) is bottom left
  final int positionX;
  final int positionY;
  Position(this.positionX, this.positionY);
}

class BucketSizeCells {
  final int x;
  final int y;
  BucketSizeCells(this.x, this.y);
}

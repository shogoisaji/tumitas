import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';

class Bucket {
  final Color color;
  final BucketSize bucketSize;
  List<Map<String, dynamic>>
      bucketIntoBlock; // [{ 'block': Block, 'position': Position },...]
  List<int> bucketMaxPosition;

  Bucket({
    required this.color,
    required this.bucketSize,
    List<Map<String, dynamic>> bucketIntoBlock = const [],
    List<int> bucketMaxPosition = const [],
  })  : this.bucketIntoBlock = bucketIntoBlock,
        this.bucketMaxPosition = bucketMaxPosition {
    mocIntoBucket();
  }

// moc
  void mocIntoBucket() {
    bucketIntoBlock = [
      {
        'block': Block(Colors.red, BlockSize(1, 1), title: 'sample1'),
        'position': Position(0, 0)
      },
      {
        'block': Block(Colors.blue, BlockSize(2, 1), title: 'sample2'),
        'position': Position(1, 1)
      },
      {
        'block': Block(Colors.green, BlockSize(2, 2), title: 'sample3'),
        'position': Position(2, 2)
      },
      {
        'block': Block(Colors.orange, BlockSize(2, 1), title: 'sample4'),
        'position': Position(0, 2)
      },
      {
        'block': Block(Colors.grey, BlockSize(2, 1), title: 'sample5'),
        'position': Position(3, 4)
      },
      {
        'block': Block(Colors.teal, BlockSize(1, 1), title: 'sample6'),
        'position': Position(4, 0)
      },
      {
        'block': Block(Colors.black26, BlockSize(2, 1), title: 'sample7'),
        'position': Position(2, 0)
      },
    ];
  }

  List<Position> dismantleBlockPosition(Block block, Position position) {
    List<Position> dismantlePosition = [];
    block.blockSize.x;
    block.blockSize.y;
    for (int i = 0; i < block.blockSize.x; i++) {
      for (int j = 0; j < block.blockSize.y; j++) {
        dismantlePosition
            .add(Position(position.positionX + i, position.positionY + j));
      }
    }
    return dismantlePosition;
  }

  int getMaxPositionY(Block block, int selectPositionX) {
    List<Position> existPosition = [];
    int maxPositionY = 0;

    for (int i = 0; i < bucketIntoBlock.length; i++) {
      existPosition.addAll(dismantleBlockPosition(
          bucketIntoBlock[i]['block'], bucketIntoBlock[i]['position']));
    }
    for (int w = 0; w < block.blockSize.x; w++) {
      for (int l = 0; l < existPosition.length; l++) {
        if (existPosition[l].positionX == selectPositionX + w &&
            existPosition[l].positionY > maxPositionY) {
          maxPositionY = existPosition[l].positionY;
        }
      }
    }
    return maxPositionY;
  }

  bool addNewBlock(Block newBlock, int newPositionX) {
    final maxPositionY = getMaxPositionY(newBlock, newPositionX);
    if (maxPositionY + newBlock.blockSize.y > bucketSize.y - 1) {
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

class BucketSize {
  final int x;
  final int y;
  BucketSize(this.x, this.y);
}

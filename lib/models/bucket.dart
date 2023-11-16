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
        'block': Block(Colors.red, BlockSize(1, 1), BlockType.block1x1),
        'position': Position(0, 0)
      },
      {
        'block': Block(Colors.red, BlockSize(2, 1), BlockType.block2x1),
        'position': Position(1, 1)
      },
      {
        'block': Block(Colors.red, BlockSize(2, 2), BlockType.block2x2),
        'position': Position(2, 2)
      },
      {
        'block': Block(Colors.red, BlockSize(2, 1), BlockType.block2x2),
        'position': Position(0, 2)
      },
      {
        'block': Block(Colors.red, BlockSize(1, 1), BlockType.block2x2),
        'position': Position(4, 4)
      },
    ];
  }

  List<Position> getExistPosition() {
    List<Position> existPosition = [];
    for (int i = 0; i < bucketIntoBlock.length; i++) {
      final int positionCount = bucketIntoBlock[i]['block'].blockSize.x *
          bucketIntoBlock[i]['block'].blockSize.y;
      for (int j = 0; j < positionCount; j++) {
        final Position addPosition = Position(
            bucketIntoBlock[i]['position'].positionX +
                j % bucketIntoBlock[i]['block'].blockSize.x,
            bucketIntoBlock[i]['position'].positionY +
                j ~/ bucketIntoBlock[i]['block'].blockSize.x);
        existPosition.add(addPosition);
      }
    }
    return existPosition;
  }

  void getMaxPosition() {
    List<Position> existPosition = getExistPosition();
    for (int a = 0; a < bucketSize.x; a++) {
      print(existPosition.length);
      for (int b = 0; b < existPosition.length; b++) {
        if (bucketMaxPosition[a] > existPosition[b].positionY &&
            existPosition[b].positionX == a) {
          bucketMaxPosition[a] = existPosition[b].positionY;
        }
      }
    }
    debugPrint(bucketMaxPosition.toString());
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

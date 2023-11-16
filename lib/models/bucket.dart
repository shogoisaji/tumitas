import 'package:flutter/material.dart';

class Bucket {
  final Color color;
  final BucketSize bucketSize;
  List<Map<String, dynamic>> bucketIntoBlock;// [{ block: Block, position: Position },...]
  List<int> bucketMaxPosition;
  
  Bucket(
      {required this.color,
      required this.bucketSize,
      this.bucketIntoBlock = const [],
      this.bucketMaxPosition = const []}) {
    initializeBucketIntoData();
  }

  void initializeBucketIntoData() {
    bucketIntoBlock = [];
    for (int i = 0; i < bucketSize.x * bucketSize.y; i++) {
      // bucketIntoData.add(0);
    }
  }

  void getMaxPosition(){
    List<Position> existPosition = [];
    for (int i = 0; i < bucketIntoBlock.length; i++) {
      final int positionCount = switch(bucketIntoBlock[i]['block'].blockSize.x){
        case 1:
          return 1;
        case 2:
          return 2;
        case 3:
          return 3;
        default:
          return 1;
      }
      existPosition.add(bucketIntoBlock[i]['position']);
    }
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

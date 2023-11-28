import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';
import 'dart:convert';

class Bucket {
  final String bucketTitle;
  final String bucketDescription;
  final Color bucketInnerColor;
  final Color bucketOuterColor;
  final BucketLayoutSize bucketLayoutSize;
  final List<Map<String, dynamic>>
      bucketIntoBlock; // [{ 'block': Block, 'position': Position },...]

  Bucket({
    required this.bucketTitle,
    required this.bucketDescription,
    required this.bucketInnerColor,
    required this.bucketOuterColor,
    required this.bucketLayoutSize,
    required this.bucketIntoBlock,
  });

  String jsonEncodeBucketIntoBlock() {
    List<String> encodedBucketIntoBlock = [];
    for (int i = 0; i < bucketIntoBlock.length; i++) {
      encodedBucketIntoBlock.add(json.encode({
        'block': bucketIntoBlock[i]['block'].toJson(),
        'position': bucketIntoBlock[i]['position'].toJson(),
      }));
    }
    return json.encode(encodedBucketIntoBlock);
  }

  static List<Map<String, String>> jsonDecodeBucketIntoBlock(
      List<dynamic> encodedList) {
    return encodedList.map((encodedItem) {
      Map<String, dynamic> decoded = json.decode(encodedItem);
      return {
        'block': Block.fromJson(decoded['block']) as String,
        'position': Position.fromJson(decoded['position']) as String,
      };
    }).toList();
  }
  // static List<Map<String, dynamic>> jsonDecodeBucketIntoBlock(
  //     List<String> encodedList) {
  //   return encodedList.map((encodedItem) {
  //     Map<String, dynamic> decoded = json.decode(encodedItem);
  //     return {
  //       'block': Block.fromJson(decoded['block']),
  //       'position': Position.fromJson(decoded['position']),
  //     };
  //   }).toList();
  // }

  Map<String, dynamic> toJson() => {
        'bucketTitle': bucketTitle,
        'bucketDescription': bucketDescription,
        'bucketInnerColor': bucketInnerColor.value,
        'bucketOuterColor': bucketOuterColor.value,
        'bucketLayoutSize': bucketLayoutSize.toJson(),
        'bucketIntoBlock': jsonEncodeBucketIntoBlock(),
      };

  factory Bucket.fromJson(Map<String, dynamic> json) {
    return Bucket(
      bucketTitle: json['bucketTitle'],
      bucketDescription: json['bucketDescription'],
      bucketInnerColor: Color(json['bucketInnerColor']),
      bucketOuterColor: Color(json['bucketOuterColor']),
      bucketLayoutSize: BucketLayoutSize.fromJson(json['bucketLayoutSize']),
      bucketIntoBlock:
          jsonDecodeBucketIntoBlock(json['bucketIntoBlock'].cast<String>()),
    );
  }

  List<Position> fragmentBlockPosition(Block block, Position position) {
    List<Position> dismantlePosition = [];
    block.blockType.blockSize.x;
    block.blockType.blockSize.y;
    for (int i = 0; i < block.blockType.blockSize.x; i++) {
      for (int j = 0; j < block.blockType.blockSize.y; j++) {
        dismantlePosition
            .add(Position(position.positionX + i, position.positionY + j));
      }
    }
    return dismantlePosition;
  }

  int getMaxPositionY(Block block, int selectPositionX) {
    List<Position> existPosition = [];
    int maxPositionY = -1;

    for (int i = 0; i < bucketIntoBlock.length; i++) {
      existPosition.addAll(fragmentBlockPosition(
          bucketIntoBlock[i]['block'], bucketIntoBlock[i]['position']));
    }
    for (int w = 0; w < block.blockType.blockSize.x; w++) {
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
    if (maxPositionY + newBlock.blockType.blockSize.y >
        bucketLayoutSize.y - 1) {
      return false;
    }
    final newPosition = Position(newPositionX, maxPositionY + 1);
    print('Type of bucketIntoBlock: ${bucketIntoBlock.runtimeType}');

    bucketIntoBlock.add(
        {'block': newBlock as dynamic, 'position': newPosition as dynamic});
    return true;
  }
}

class Position {
  // (0,0) is bottom left
  final int positionX;
  final int positionY;
  Position(this.positionX, this.positionY);

  Map<String, dynamic> toJson() => {
        'positionX': positionX,
        'positionY': positionY,
      };

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(json['positionX'], json['positionY']);
  }
}

class BucketLayoutSize {
  final int x;
  final int y;
  BucketLayoutSize(this.x, this.y);

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };

  factory BucketLayoutSize.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return BucketLayoutSize(json['x'], json['y']);
  }
}

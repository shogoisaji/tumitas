import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';
import 'dart:convert';

class Bucket {
  final String bucketId;
  final String bucketTitle;
  final String bucketDescription;
  final Color bucketInnerColor;
  final Color bucketOuterColor;
  final int bucketLayoutSizeX;
  final int bucketLayoutSizeY;
  final List<Map<String, dynamic>> bucketIntoBlock; // [{ 'block': Block, 'position': Position },...]
  final DateTime bucketRegisterDate;
  final DateTime? bucketArchiveDate;

  Bucket({
    required this.bucketId,
    required this.bucketTitle,
    required this.bucketDescription,
    required this.bucketInnerColor,
    required this.bucketOuterColor,
    required this.bucketLayoutSizeX,
    required this.bucketLayoutSizeY,
    required this.bucketIntoBlock,
    required this.bucketRegisterDate,
    this.bucketArchiveDate,
  });

  Bucket settingBucket(String title, Color innerColor, Color outerColor) {
    return Bucket(
      bucketId: bucketId, // no change
      bucketTitle: title,
      bucketDescription: bucketDescription, // no change
      bucketInnerColor: innerColor,
      bucketOuterColor: outerColor,
      bucketLayoutSizeX: bucketLayoutSizeX, // no change
      bucketLayoutSizeY: bucketLayoutSizeY, // no change
      bucketIntoBlock: bucketIntoBlock, // no change
      bucketRegisterDate: bucketRegisterDate, // no change
      bucketArchiveDate: bucketArchiveDate, // no change
    );
  }

  Bucket updateArchiveDate(DateTime archiveDate) {
    return Bucket(
      bucketId: bucketId, // no change
      bucketTitle: bucketTitle, // no change
      bucketDescription: bucketDescription, // no change
      bucketInnerColor: bucketInnerColor, // no change
      bucketOuterColor: bucketOuterColor, // no change
      bucketLayoutSizeX: bucketLayoutSizeX, // no change
      bucketLayoutSizeY: bucketLayoutSizeY, // no change
      bucketIntoBlock: bucketIntoBlock, // no change
      bucketRegisterDate: bucketRegisterDate, // no change
      bucketArchiveDate: archiveDate,
    );
  }

  String jsonEncodeBucketIntoBlock() {
    List<String> encodedBucketIntoBlock = [];
    for (int i = 0; i < bucketIntoBlock.length; i++) {
      encodedBucketIntoBlock.add(json.encode({
        'block': bucketIntoBlock[i]['block'].blockToJson(),
        'position': bucketIntoBlock[i]['position'].positionToJson(),
      }));
    }
    return json.encode(encodedBucketIntoBlock);
  }

  static List<Map<String, dynamic>> jsonDecodeBucketIntoBlock(List<dynamic> encodedList) {
    if (encodedList.isEmpty) {
      return [];
    }
    final bucketIntoBlocks = encodedList.map((encodedItem) {
      Map<String, dynamic> decoded = json.decode(encodedItem);
      return {
        'block': Block.blockFromJson(decoded['block']),
        'position': Position.positionFromJson(decoded['position']),
      };
    }).toList();
    return bucketIntoBlocks;
  }

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

  void addNewBlock(Block newBlock, int newPositionX, int newPositionY) {
    final newPosition = Position(newPositionX, newPositionY);
    Map<String, Object> newBucketIntoBlock = {'block': newBlock, 'position': newPosition};
    bucketIntoBlock.add(newBucketIntoBlock);
  }
}

class Position {
  // (0,0) is bottom left
  final int positionX;
  final int positionY;
  Position(this.positionX, this.positionY);

  Map<String, dynamic> positionToJson() => {
        'positionX': positionX,
        'positionY': positionY,
      };

  factory Position.positionFromJson(Map<String, dynamic> json) {
    return Position(json['positionX'], json['positionY']);
  }
}

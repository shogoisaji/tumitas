import 'package:flutter/material.dart';

class Bucket {
  final Color color;
  final BucketSize bucketSize;
  List<int> bucketIntoData;

  Bucket(
      {required this.color,
      required this.bucketSize,
      this.bucketIntoData = const []}) {
    initializeBucketIntoData();
  }

  void initializeBucketIntoData() {
    bucketIntoData = [];
    for (int i = 0; i < bucketSize.x * bucketSize.y; i++) {
      bucketIntoData.add(0);
    }
  }
}

class BucketSize {
  final int x;
  final int y;
  BucketSize(this.x, this.y);
}

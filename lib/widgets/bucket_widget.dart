import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/bucket.dart';

class BucketWidget extends StatelessWidget {
  final Bucket bucket;
  const BucketWidget(this.bucket, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double offsetSize = 5;

    return Container(
      alignment: Alignment.bottomCenter,
      width: bucket.bucketSize.x * oneBlockSize + offsetSize * 2,
      height: bucket.bucketSize.y * oneBlockSize + offsetSize * 2,
      padding: const EdgeInsets.only(bottom: offsetSize),
      decoration: BoxDecoration(
        color: bucket.color,
        borderRadius: const BorderRadius.only(
          // Add this line
          bottomLeft: Radius.circular(10 + offsetSize),
          bottomRight: Radius.circular(10 + offsetSize),
        ),
      ),
      child: Container(
        width: bucket.bucketSize.x * oneBlockSize,
        height: bucket.bucketSize.y * oneBlockSize + offsetSize * 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            // Add this line
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
    );
  }
}

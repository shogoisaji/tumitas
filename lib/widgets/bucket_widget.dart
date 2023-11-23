import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/widgets/block_widget.dart';

class BucketWidget extends StatelessWidget {
  final Bucket bucket;
  const BucketWidget(this.bucket, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double bucketThickness = 5;

    return Column(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          width: bucket.bucketSizeCells.x * oneBlockSize + bucketThickness * 2,
          height: bucket.bucketSizeCells.y * oneBlockSize + bucketThickness * 2,
          padding: const EdgeInsets.only(bottom: bucketThickness),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: bucket.color,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10 + bucketThickness),
              bottomRight: Radius.circular(10 + bucketThickness),
            ),
          ),
          child: Container(
            width: bucket.bucketSizeCells.x * oneBlockSize,
            height: bucket.bucketSizeCells.y * oneBlockSize + bucketThickness * 2,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Stack(children: [
              // bucketIntoBlockをそれぞれbucket内に配置
              for (int i = 0; i < bucket.bucketIntoBlock.length; i++)
                Positioned(
                  left: bucket.bucketIntoBlock[i]['position'].positionX * oneBlockSize,
                  bottom: bucket.bucketIntoBlock[i]['position'].positionY * oneBlockSize,
                  child: BlockWidget(
                    bucket.bucketIntoBlock[i]['block'],
                  ),
                ),
            ]),
          ),
        ),
        Text(
          bucket.bucketTitle,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

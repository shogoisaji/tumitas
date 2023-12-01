import 'package:flutter/material.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/block_widget.dart';

class BucketWidget extends StatelessWidget {
  final Bucket bucket;
  final double oneBlockSize;
  const BucketWidget(this.bucket, this.oneBlockSize, {super.key});

  @override
  Widget build(BuildContext context) {
    const double bucketThickness = 5;
    const double innerOffset = 1;

    return Column(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          width: bucket.bucketLayoutSizeX * oneBlockSize + bucketThickness * 2 + innerOffset * 2,
          height: bucket.bucketLayoutSizeY * oneBlockSize + bucketThickness * 2,
          padding: const EdgeInsets.only(bottom: bucketThickness),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: bucket.bucketOuterColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10 + bucketThickness),
              bottomRight: Radius.circular(10 + bucketThickness),
            ),
          ),
          child: Container(
            width: bucket.bucketLayoutSizeX * oneBlockSize + innerOffset * 2,
            height: bucket.bucketLayoutSizeY * oneBlockSize + bucketThickness * 2,
            padding: const EdgeInsets.only(left: innerOffset, right: innerOffset, bottom: innerOffset),
            decoration: BoxDecoration(
              color: bucket.bucketInnerColor,
              borderRadius: const BorderRadius.only(
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
                    oneBlockSize,
                  ),
                ),
            ]),
          ),
        ),
        Text(
          bucket.bucketTitle,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: MyTheme.grey1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

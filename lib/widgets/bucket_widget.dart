import 'package:flutter/material.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/block_widget.dart';
import 'package:tumitas/widgets/dialog/block_detail_dialog.dart';

class BucketWidget extends StatelessWidget {
  final Bucket bucket;
  final double oneBlockSize;
  const BucketWidget(this.bucket, this.oneBlockSize, {super.key});

  @override
  Widget build(BuildContext context) {
    const double bucketThickness = 5;
    const double innerOffset = 1;
    final double borderRadius = oneBlockSize / 7;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          width: bucket.bucketLayoutSizeX * oneBlockSize + bucketThickness * 2 + innerOffset * 2,
          height: bucket.bucketLayoutSizeY * oneBlockSize + bucketThickness * 2,
          padding: const EdgeInsets.only(bottom: bucketThickness),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: bucket.bucketOuterColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(borderRadius + bucketThickness),
              bottomRight: Radius.circular(borderRadius + bucketThickness),
            ),
          ),
          child: Container(
            width: bucket.bucketLayoutSizeX * oneBlockSize + innerOffset * 2,
            height: bucket.bucketLayoutSizeY * oneBlockSize + bucketThickness * 2,
            padding: const EdgeInsets.only(left: innerOffset, right: innerOffset, bottom: innerOffset),
            decoration: BoxDecoration(
              color: bucket.bucketInnerColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
            ),
            child: Stack(children: [
              // bucketIntoBlockをそれぞれbucket内に配置
              for (int i = 0; i < bucket.bucketIntoBlock.length; i++)
                Positioned(
                  left: bucket.bucketIntoBlock[i]['position'].positionX * oneBlockSize,
                  bottom: bucket.bucketIntoBlock[i]['position'].positionY * oneBlockSize,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BlockDetailDialog(block: bucket.bucketIntoBlock[i]['block']);
                        },
                      );
                    },
                    child: BlockWidget(
                      bucket.bucketIntoBlock[i]['block'],
                      oneBlockSize,
                    ),
                  ),
                ),
            ]),
          ),
        ),
        Text(
          bucket.bucketTitle,
          style: TextStyle(
              fontSize: oneBlockSize > 50 ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: MyTheme.grey1,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

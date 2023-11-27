import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/services/shared_preferences_helper.dart';
import 'package:tumitas/widgets/multi_floating_buttom.dart';
import 'package:tumitas/widgets/play_space_widget.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  String nextBlockTitle = '';
  Block? nextSettingBlock;

  Bucket currentBucket = Bucket(
    bucketTitle: 'Bucket Title',
    bucketInnerColor: bucketInnerColorList[2],
    bucketOuterColor: bucketOuterColorList[1],
    bucketLayoutSize: BucketLayoutSize(5, 6),
    bucketIntoBlock: [],
  );

  void _handleSetBucket(Map<String, dynamic> settingBucketProperties) {
    final Bucket changeBucket = Bucket(
      bucketTitle: settingBucketProperties['title'],
      bucketInnerColor: settingBucketProperties['innerColor'],
      bucketOuterColor: settingBucketProperties['outerColor'],
      bucketLayoutSize: currentBucket.bucketLayoutSize,
      bucketIntoBlock: currentBucket.bucketIntoBlock,
    );
    setState(() {
      currentBucket = changeBucket;
    });
  }

  void _handleSetBlock(Block block) {
    setState(() {
      nextSettingBlock = block;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PlaySpaceWidget(
                    bucket: currentBucket,
                    nextSettingBlock: nextSettingBlock,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                SharedPreferencesHelper().saveBucket(currentBucket);
              },
              child: const Text('save'),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () async {
                final Bucket? loadBucket = await SharedPreferencesHelper().loadBucket();
                print(loadBucket?.bucketIntoBlock.toString());
                // if (bucket != null) {
                //   setState(() {
                //     this.bucket = bucket;
                //   });
                // }
              },
              child: const Text('load'),
            ),
          ),
          MultiFloatingBottom(
            currentBucket: currentBucket,
            onSetBucket: _handleSetBucket,
            onSetBlock: _handleSetBlock,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/services/shared_preferences_helper.dart';
import 'package:tumitas/services/sqflite_helper.dart';
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
    bucketTitle: 'default',
    bucketDescription: 'default',
    bucketInnerColor: bucketInnerColorList[0],
    bucketOuterColor: bucketOuterColorList[0],
    bucketLayoutSize: BucketLayoutSize(5, 5),
    bucketIntoBlock: [],
  );

  void _handleSetBucket(Map<String, dynamic> settingBucketProperties) {
    final Bucket changeBucket = Bucket(
      bucketTitle: settingBucketProperties['title'],
      bucketDescription: settingBucketProperties['description'] ?? 'default',
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

  void saveCurrentBucket(Bucket bucket) async {
    final int? bucketId = await SqfliteHelper.instance.insertBucket(bucket);
    print('savedBucketId: $bucketId');
  }

  Future<Bucket?> loadBucket() async {
    // final int? bucketId = await SharedPreferencesHelper().loadCurrentBucketId();
    final bucketId = 2;
    if (bucketId != null) {
      final Bucket? bucket = await SqfliteHelper.instance.findById(bucketId);
      print('loadedBucketId: $bucketId');
      return bucket;
    }
    return null;
  }

  @override
  initState() {
    super.initState();
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
                  const SizedBox(height: 24),
                  FutureBuilder(
                    future: loadBucket(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Bucket?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error'));
                      } else if (snapshot.hasData) {
                        return PlaySpaceWidget(
                          bucket: snapshot.data!,
                          nextSettingBlock: nextSettingBlock,
                        );
                      } else {
                        return const Center(child: Text('No Current Bucket'));
                      }
                    },
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
                saveCurrentBucket(currentBucket);
              },
              child: const Text('save'),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () async {
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

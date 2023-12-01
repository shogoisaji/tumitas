import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/services/shared_preferences_helper.dart';
import 'package:tumitas/services/sqflite_helper.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/bucket_registration_dialog.dart';
import 'package:tumitas/widgets/bucket_setting_dialog.dart';
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
  int currentBucketId = 0;
  Bucket? currentBucket;

  // Bucket currentBucket = Bucket(
  //   bucketTitle: 'default',
  //   bucketDescription: 'default',
  //   bucketInnerColor: bucketInnerColorList[0],
  //   bucketOuterColor: bucketOuterColorList[0],
  //   bucketLayoutSize: BucketLayoutSize(5, 7),
  //   bucketIntoBlock: [],
  // );

  void _handleSetBucket(Map<String, dynamic> settingBucketProperties) {
    final Bucket changeBucket = Bucket(
      bucketTitle: settingBucketProperties['title'],
      bucketDescription: settingBucketProperties['description'] ?? 'default',
      bucketInnerColor: settingBucketProperties['innerColor'],
      bucketOuterColor: settingBucketProperties['outerColor'],
      bucketLayoutSizeX: bucketLayoutSizeX,
      bucketLayoutSizeY: bucketLayoutSizeY,
      bucketIntoBlock: [],
    );
    setState(() {
      currentBucket = changeBucket;
    });
    // saveCurrentBucket(changeBucket);
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
    if (currentBucketId != 0) {
      final Bucket? bucket = await SqfliteHelper.instance.findBucketById(currentBucketId);
      print('loadedBucketId: $currentBucketId');
      return bucket;
    }
    print('No Current Bucket');
    return null;
  }

  void loadCurrentBucketId() async {
    currentBucketId = await SharedPreferencesHelper().loadCurrentBucketId() ?? 0;
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadCurrentBucketId();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Stack(
            children: [
              currentBucketId == 0
                  ? Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            backgroundColor: MyTheme.green1,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => BucketRegistrationDialog(
                                      onRegisterBucket: (Map<String, dynamic> settingBucketProperties) {
                                        setState(() {
                                          _handleSetBucket(settingBucketProperties);
                                        });
                                      },
                                    ));
                          },
                          child: Container(
                            // padding: const EdgeInsets.all(4),
                            width: 100,
                            height: 60,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.account_box, color: Colors.white, size: 28),
                                Text('Bucket', style: const TextStyle(color: Colors.white, fontSize: 16))
                              ],
                            ),
                          )),
                    )
                  : SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 24),
                            FutureBuilder(
                              future: loadBucket(),
                              builder: (BuildContext context, AsyncSnapshot<Bucket?> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Center(child: Text('Error'));
                                } else if (snapshot.hasData) {
                                  return PlaySpaceWidget(
                                    bucket: snapshot.data!,
                                    nextSettingBlock: nextSettingBlock,
                                    currentBucketId: currentBucketId,
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
                    SharedPreferencesHelper().saveCurrentBucketId(1);
                    setState(() {});
                  },
                  child: const Text('save'),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {});
                  },
                  child: const Text('load'),
                ),
              ),
            ],
          ),
        ),
        MultiFloatingBottom(
          currentBucket: currentBucket,
          onSetBucket: _handleSetBucket,
          onSetBlock: _handleSetBlock,
        ),
      ],
    );
  }
}

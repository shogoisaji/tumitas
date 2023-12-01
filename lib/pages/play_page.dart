import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/services/shared_preferences_helper.dart';
import 'package:tumitas/services/sqflite_helper.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/dialog/bucket_registration_dialog.dart';
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

  // change prop of title, innerColor, outerColor
  void _handleSettingBucket(Map<String, dynamic> settingBucketProperties) {
    if (currentBucket == null) return;
    final Bucket changeBucket = Bucket(
      bucketTitle: settingBucketProperties['title'],
      bucketDescription: currentBucket!.bucketDescription,
      bucketInnerColor: settingBucketProperties['innerColor'],
      bucketOuterColor: settingBucketProperties['outerColor'],
      bucketLayoutSizeX: bucketLayoutSizeX,
      bucketLayoutSizeY: bucketLayoutSizeY,
      bucketIntoBlock: currentBucket!.bucketIntoBlock,
      bucketRegisterDate: currentBucket!.bucketRegisterDate,
      bucketArchiveDate: currentBucket!.bucketArchiveDate,
    );
    setState(() {
      currentBucket = changeBucket;
    });
    updateCurrentBucket(changeBucket, currentBucketId);
  }

  void _handleRegisterBucket(Map<String, dynamic> settingBucketProperties) {
    final Bucket changeBucket = Bucket(
      bucketTitle: settingBucketProperties['title'],
      bucketDescription: 'default',
      bucketInnerColor: settingBucketProperties['innerColor'],
      bucketOuterColor: settingBucketProperties['outerColor'],
      bucketLayoutSizeX: bucketLayoutSizeX,
      bucketLayoutSizeY: bucketLayoutSizeY,
      bucketIntoBlock: [],
      bucketRegisterDate: DateTime.now(),
      bucketArchiveDate: DateTime(0),
    );
    setState(() {
      currentBucket = changeBucket;
    });
    registerBucket(changeBucket);
  }

  void _handleSetBlock(Block block) {
    setState(() {
      nextSettingBlock = block;
    });
  }

  Future<void> _handleAddArchive() async {
    if (currentBucket == null) return;
    final Bucket addArchiveBucket = Bucket(
      bucketTitle: currentBucket!.bucketTitle,
      bucketDescription: currentBucket!.bucketDescription,
      bucketInnerColor: currentBucket!.bucketInnerColor,
      bucketOuterColor: currentBucket!.bucketOuterColor,
      bucketLayoutSizeX: currentBucket!.bucketLayoutSizeX,
      bucketLayoutSizeY: currentBucket!.bucketLayoutSizeY,
      bucketIntoBlock: currentBucket!.bucketIntoBlock,
      bucketRegisterDate: currentBucket!.bucketRegisterDate,
      bucketArchiveDate: DateTime.now(),
    );
    await updateCurrentBucket(addArchiveBucket, currentBucketId);
    await SharedPreferencesHelper().saveCurrentBucketId(0);
    setState(() {
      currentBucket = null;
    });
  }

  Future<void> registerBucket(Bucket bucket) async {
    int? bucketId = await SqfliteHelper.instance.insertBucket(bucket);
    await SharedPreferencesHelper().saveCurrentBucketId(bucketId ?? 0);
    print('insertBucketId: ${bucketId ?? "null"}');
  }

  Future<void> updateCurrentBucket(Bucket bucket, int bucketId) async {
    await SqfliteHelper.instance.updateBucket(bucketId, bucket);
    print('updateBucketId: $bucketId');
  }

  Future<void> loadBucket() async {
    currentBucketId = await SharedPreferencesHelper().loadCurrentBucketId() ?? 0;
    print('currentBucketId: $currentBucketId');
    if (currentBucketId != 0) {
      final Bucket? bucket = await SqfliteHelper.instance.findBucketById(currentBucketId);
      setState(() {
        currentBucket = bucket;
        print('currentBucketTitle: ${currentBucket != null ? currentBucket!.bucketTitle : 'null'}');
      });
    } else {
      print('No Current Bucket');
    }
  }
  // Future<Bucket?> loadBucket() async {
  //   if (currentBucketId != 0) {
  //     final Bucket? bucket = await SqfliteHelper.instance.findBucketById(currentBucketId);
  //     print('loadedBucketId: $currentBucketId');
  //     return bucket;
  //   }
  //   print('No Current Bucket');
  //   return null;
  // }

  void loadCurrentBucketId() async {
    currentBucketId = await SharedPreferencesHelper().loadCurrentBucketId() ?? 0;
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadBucket();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Stack(
            children: [
              currentBucket == null
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
                                          _handleRegisterBucket(settingBucketProperties);
                                        });
                                      },
                                    ));
                          },
                          child: Container(
                            width: 140,
                            height: 60,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 28),
                                Text('New Bucket', style: TextStyle(color: Colors.white, fontSize: 16))
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
                            // FutureBuilder(
                            //   future: loadBucket(),
                            //   builder: (BuildContext context, AsyncSnapshot<Bucket?> snapshot) {
                            //     if (snapshot.connectionState == ConnectionState.waiting) {
                            //       return const Center(child: CircularProgressIndicator());
                            //     } else if (snapshot.hasError) {
                            //       return const Center(child: Text('Error'));
                            //     } else if (snapshot.hasData) {
                            //       return PlaySpaceWidget(
                            //         bucket: snapshot.data!,
                            //         nextSettingBlock: nextSettingBlock,
                            //         currentBucketId: currentBucketId,
                            //       );
                            //     } else {
                            //       return const Center(child: Text('No Current Bucket'));
                            //     }
                            //   },
                            // ),
                            currentBucket != null
                                ? PlaySpaceWidget(
                                    bucket: currentBucket!,
                                    nextSettingBlock: nextSettingBlock,
                                    currentBucketId: currentBucketId,
                                  )
                                : const Center(child: Text('No Current Bucket')),
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
          onSetBucket: _handleSettingBucket,
          onSetBlock: _handleSetBlock,
          addArchive: _handleAddArchive,
        ),
      ],
    );
  }
}

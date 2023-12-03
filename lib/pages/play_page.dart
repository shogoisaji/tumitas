import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/services/shared_preferences_helper.dart';
import 'package:tumitas/services/sqflite_helper.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/bucket_registration_bottom_sheet.dart';
import 'package:tumitas/widgets/multi_floating_buttom.dart';
import 'package:tumitas/widgets/play_space_widget.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  Block? nextPlayBlock;
  Bucket? currentBucket;
  int currentBucketId = 0;

  void _handleSettingBucket(Map<String, dynamic> settingBucketProperties) {
    if (currentBucket == null) return;
    final Bucket changeBucket = currentBucket!.settingBucket(
      settingBucketProperties['title'],
      settingBucketProperties['innerColor'],
      settingBucketProperties['outerColor'],
    );
    setState(() {
      currentBucket = changeBucket;
    });
    updateCurrentBucket(currentBucketId, changeBucket);
  }

  void _handleRegisterBucket(Map<String, dynamic> settingBucketProperties) async {
    final Bucket changeBucket = Bucket(
      bucketTitle: settingBucketProperties['title'],
      bucketDescription: 'default',
      bucketInnerColor: settingBucketProperties['innerColor'],
      bucketOuterColor: settingBucketProperties['outerColor'],
      bucketLayoutSizeX: bucketLayoutSizeX,
      bucketLayoutSizeY: bucketLayoutSizeY,
      bucketIntoBlock: [],
      bucketRegisterDate: DateTime.now(),
      bucketArchiveDate: null,
    );
    final int bucketId = await registerBucket(changeBucket) ?? 0;
    setState(() {
      currentBucket = changeBucket;
      currentBucketId = bucketId;
    });
  }

  void _handleSetBlock(Block block) {
    setState(() {
      nextPlayBlock = block;
    });
  }

  Future<void> _handleAddArchive() async {
    if (currentBucket == null) return;
    final Bucket addArchiveBucket = currentBucket!.updateArchiveDate(DateTime.now());
    print('bbb ${currentBucketId}');

    await updateCurrentBucket(currentBucketId, addArchiveBucket);
    await SharedPreferencesHelper().saveCurrentBucketId(0);
    setState(() {
      currentBucket = null;
      nextPlayBlock = null;
    });
  }

  Future<int?> registerBucket(Bucket bucket) async {
    int? bucketId = await SqfliteHelper.instance.insertBucket(bucket);
    await SharedPreferencesHelper().saveCurrentBucketId(bucketId ?? 0);
    print('insertBucketId: ${bucketId ?? "null"}');
    return bucketId;
  }

  Future<void> updateCurrentBucket(int bucketId, Bucket bucket) async {
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
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) => BucketRegistrationBottomSheet(
                                      onRegisterBucket: (Map<String, dynamic> settingBucketProperties) {
                                        setState(() {
                                          _handleRegisterBucket(settingBucketProperties);
                                        });
                                      },
                                    ));
                          },
                          child: const SizedBox(
                            width: 140,
                            height: 60,
                            child: Row(
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
                            currentBucket != null
                                ? PlaySpaceWidget(
                                    bucket: currentBucket!,
                                    nextSettingBlock: nextPlayBlock,
                                    currentBucketId: currentBucketId,
                                  )
                                : const Center(child: Text('No Current Bucket')),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
        currentBucket != null
            ? MultiFloatingBottom(
                currentBucket: currentBucket,
                onSetBucket: _handleSettingBucket,
                onSetBlock: _handleSetBlock,
                addArchive: _handleAddArchive,
              )
            : Container(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tumitas/animations/cloud_animation.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/services/shared_preferences_helper.dart';
import 'package:tumitas/services/sqflite_helper.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/bottom_sheet/bucket_registration_bottom_sheet.dart';
import 'package:tumitas/widgets/multi_floating_buttom.dart';
import 'package:tumitas/widgets/play_space_widget.dart';
import 'package:uuid/uuid.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  Block? nextPlayBlock;
  Bucket? currentBucket;
  String currentBucketId = '';

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
      bucketId: const Uuid().v4(),
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
    await registerBucket(changeBucket);
    loadBucket();
  }

  void _handleSetBlock(Block block) {
    setState(() {
      nextPlayBlock = block;
    });
  }

  Future<void> _handleAddArchive() async {
    if (currentBucket == null) return;
    final Bucket addArchiveBucket = currentBucket!.updateArchiveDate(DateTime.now());

    await updateCurrentBucket(currentBucketId, addArchiveBucket);
    await SharedPreferencesHelper().saveCurrentBucketId('');
    setState(() {
      currentBucket = null;
      nextPlayBlock = null;
    });
  }

  Future<void> registerBucket(Bucket bucket) async {
    await SqfliteHelper.instance.insertBucket(bucket);
    await SharedPreferencesHelper().saveCurrentBucketId(bucket.bucketId);
  }

  Future<void> updateCurrentBucket(String bucketId, Bucket bucket) async {
    await SqfliteHelper.instance.updateBucket(bucketId, bucket);
  }

  Future<void> loadBucket() async {
    currentBucketId = await SharedPreferencesHelper().loadCurrentBucketId() ?? '';
    if (currentBucketId != '') {
      final Bucket? bucket = await SqfliteHelper.instance.findBucketById(currentBucketId);
      if (bucket == null) {
        return;
      }
      setState(() {
        currentBucket = bucket;
      });
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
              CloudAnimation(
                duration: 9,
                child: Transform.translate(
                  offset: const Offset(80, 30),
                  child: Image.asset(
                    'assets/images/cloud3.png',
                    fit: BoxFit.cover,
                    width: 90,
                  ),
                ),
              ),
              CloudAnimation(
                duration: 11,
                child: Transform.translate(
                  offset: const Offset(10, 60),
                  child: Image.asset(
                    'assets/images/cloud1.png',
                    fit: BoxFit.cover,
                    width: 120,
                  ),
                ),
              ),
              CloudAnimation(
                duration: 13,
                child: Transform.translate(
                  offset: const Offset(220, 40),
                  child: Image.asset(
                    'assets/images/cloud2.png',
                    fit: BoxFit.cover,
                    width: 120,
                  ),
                ),
              ),
              CloudAnimation(
                duration: 10,
                child: Transform.translate(
                  offset: const Offset(150, 80),
                  child: Image.asset(
                    'assets/images/cloud4.png',
                    fit: BoxFit.cover,
                    width: 120,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Transform.rotate(
                  angle: -0.15,
                  child: Image.asset(
                    'assets/images/title_logo.png',
                    fit: BoxFit.cover,
                    width: 200,
                  ),
                ),
              ),
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
                            width: 150,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 28),
                                Text('New Bucket', style: TextStyle(color: Colors.white, fontSize: 18))
                              ],
                            ),
                          )),
                    )
                  : SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 32),
                            PlaySpaceWidget(
                              bucket: currentBucket!,
                              nextSettingBlock: nextPlayBlock,
                              currentBucketId: currentBucketId,
                            )
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumitas/main.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/services/sqflite_helper.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/bottom_sheet/detail_bucket_setting_bottom_sheet.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class DetailPage extends StatefulWidget {
  final Bucket selectedBucket;
  const DetailPage(this.selectedBucket, {super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  void _handleSettingBucket(Map<String, dynamic> settingBucketProperties) async {
    final Bucket changeBucket = widget.selectedBucket.settingBucket(
      settingBucketProperties['title'],
      settingBucketProperties['innerColor'],
      settingBucketProperties['outerColor'],
    );
    await updateSelectedBucket(widget.selectedBucket.bucketId, changeBucket);
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  Future<void> updateSelectedBucket(String bucketId, Bucket bucket) async {
    await SqfliteHelper.instance.updateBucket(bucketId, bucket);
    print('updateBucketId: $bucketId');
  }

  Future<void> _handleDeleteBucket(String bucketId) async {
    await SqfliteHelper.instance.deleteRow(bucketId);
    print('deleteBucketId: $bucketId');
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double oneBlockSize = (MediaQuery.of(context).size.width - 50) / widget.selectedBucket.bucketLayoutSizeX;

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MyTheme.blue1, MyTheme.green5],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(formatDate(widget.selectedBucket.bucketRegisterDate.toIso8601String()),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.grey1,
                            overflow: TextOverflow.ellipsis)),
                    const Text(' 〜 ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyTheme.grey1)),
                    Text(formatDate(widget.selectedBucket.bucketArchiveDate!.toIso8601String()),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.grey1,
                            overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                BucketWidget(widget.selectedBucket, oneBlockSize),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        backgroundColor: MyTheme.green1,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                        width: 120,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                            Text('Back',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => DetailBucketSettingBottomSheet(
                            selectedBucket: widget.selectedBucket,
                            deleteBucket: (String bucketId) {
                              _handleDeleteBucket(bucketId);
                              print("deleteBucket: $bucketId");
                            },
                            onSettingDetailPageBucket: (Map<String, dynamic> settingBucketProperties) {
                              _handleSettingBucket(settingBucketProperties);
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        backgroundColor: MyTheme.green1,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                        width: 120,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.settings, color: Colors.white, size: 22),
                            Text('Setting',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class DetailPage extends StatefulWidget {
  final Bucket bucket;
  const DetailPage(this.bucket, {super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final double oneBlockSize = (MediaQuery.of(context).size.width - 50) / widget.bucket.bucketLayoutSizeX;

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MyTheme.blue2, MyTheme.green5],
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
                    Text(formatDate(widget.bucket.bucketRegisterDate.toIso8601String()),
                        style: const TextStyle(fontSize: 20, color: MyTheme.grey1, overflow: TextOverflow.ellipsis)),
                    const Text('〜', style: TextStyle(fontSize: 18, color: MyTheme.grey1)),
                    Text(formatDate(widget.bucket.bucketArchiveDate!.toIso8601String()),
                        style: const TextStyle(fontSize: 20, color: MyTheme.grey1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                BucketWidget(widget.bucket, oneBlockSize),
                const SizedBox(height: 16),
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
                        Text('Back', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

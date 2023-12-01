import 'package:flutter/material.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class DetailPage extends StatefulWidget {
  final Bucket bucket;
  DetailPage(this.bucket);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final double oneBlockSize = (MediaQuery.of(context).size.width - 50) / widget.bucket.bucketLayoutSizeX;

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MyTheme.blue2, MyTheme.green5],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text('Detail Page', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 50,
              ),
              BucketWidget(widget.bucket, oneBlockSize),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

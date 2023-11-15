import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/widgets/block_widget.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

Block block1x1 = BlockType.block2x2.block;
Bucket bucket = Bucket(color: Colors.grey, bucketSize: BucketSize(5, 10));

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red[200],
                    child: Stack(children: [
                      Positioned(top: 0, child: BlockWidget(block1x1)),
                      Positioned(
                          bottom: 20, left: 20, child: BucketWidget(bucket))
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            color: Colors.green[200],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
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

  Bucket bucket = Bucket(
      bucketTitle: 'Bucket Title',
      bucketInnerColor: bucketInnerColorList[2],
      bucketOuterColor: bucketOuterColorList[1],
      bucketSizeCells: BucketSizeCells(5, 6),
      bucketIntoBlock: [],
      bucketMaxPosition: []);

  void _handleSubmitted(String newTitle) {
    setState(() {
      nextBlockTitle = newTitle;
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
                    bucket: bucket,
                    nextBlockTitle: nextBlockTitle,
                    nextSettingBlock: nextSettingBlock,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: MultiFloatingBottom(
              onSubmittedText: _handleSubmitted,
              onSetBlock: _handleSetBlock,
            ),
          )
        ],
      ),
    );
  }
}

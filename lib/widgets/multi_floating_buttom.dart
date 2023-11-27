import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/block_setting_dialog.dart';
import 'package:tumitas/widgets/bucket_setting_dialog.dart';

class MultiFloatingBottom extends StatefulWidget {
  final Bucket currentBucket;
  final Function(Map<String, dynamic>) onSetBucket;
  final Function(Block) onSetBlock;

  const MultiFloatingBottom(
      {super.key, required this.onSetBucket, required this.onSetBlock, required this.currentBucket});

  @override
  State<MultiFloatingBottom> createState() => _MultiFloatingBottomState();
}

class _MultiFloatingBottomState extends State<MultiFloatingBottom> {
  bool isPressed = false;
  String nextBlockTitle = '';

  void _handleSetBucket(Map<String, dynamic> settingBucketProperties) {
    setState(() {
      widget.onSetBucket(settingBucketProperties);
    });
  }

  void _handleSetBlock(Block block) {
    setState(() {
      widget.onSetBlock(block);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> floatingButtonList = [
      {
        'icon': Icons.note_alt,
        'onPressed': () {
          setState(() {
            isPressed = false;
          });
          showDialog(
            context: context,
            builder: (_) => BlockSettingDialog(
              onSetting: (Block block) {
                setState(() {
                  _handleSetBlock(block);
                });
              },
            ),
          );
        },
      },
      {
        'icon': Icons.change_circle,
        'onPressed': () {
          setState(() {
            isPressed = false;
          });
          showDialog(
            context: context,
            builder: (_) => BucketSettingDialog(
              bucket: widget.currentBucket,
              onSettingBucket: (Map<String, dynamic> settingBucketProperties) {
                setState(() {
                  _handleSetBucket(settingBucketProperties);
                });
              },
            ),
          );
        },
      },
      {
        'icon': Icons.menu_book,
        'onPressed': () {
          setState(() {
            isPressed = false;
          });
        },
      },
    ];

    return isPressed
        ? GestureDetector(
            onTap: () {
              setState(() {
                isPressed = false;
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black26,
                    Colors.black54,
                  ],
                ),
              ),
              alignment: Alignment.bottomRight,
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 12, right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...floatingButtonList.map((floatingButton) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            FloatingActionButton(
                              shape: const CircleBorder(),
                              elevation: 4,
                              backgroundColor: MyTheme.green1,
                              onPressed: floatingButton['onPressed'],
                              child: Icon(floatingButton['icon'], color: Colors.white, size: 28),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  )),
            ),
          )
        : Container(
            alignment: Alignment.bottomRight,
            width: double.infinity,
            height: double.infinity,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 12, right: 12),
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  elevation: 4,
                  backgroundColor: MyTheme.green1,
                  onPressed: () {
                    setState(() {
                      isPressed = true;
                    });
                  },
                  child: const Icon(Icons.menu_book, color: Colors.white, size: 28),
                )),
          );
  }
}

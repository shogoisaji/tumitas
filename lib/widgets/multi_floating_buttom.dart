import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/block_setting_dialog.dart';
import 'package:tumitas/widgets/bucket_setting_dialog.dart';

class MultiFloatingBottom extends StatefulWidget {
  final Bucket? currentBucket;
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
        'title': 'Task    ',
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
        'title': 'Bucket',
        'onPressed': () {
          setState(() {
            isPressed = false;
          });
          if (widget.currentBucket != null) {
            showDialog(
              context: context,
              builder: (_) => BucketSettingDialog(
                currentBucket: widget.currentBucket!,
                onSettingBucket: (Map<String, dynamic> settingBucketProperties) {
                  setState(() {
                    _handleSetBucket(settingBucketProperties);
                  });
                },
              ),
            );
          } else {
            debugPrint('currentBucket is null');
          }
        },
      },
      // {
      //   'icon': Icons.menu_book,
      //   'title': '',
      //   'onPressed': () {
      //     setState(() {
      //       isPressed = false;
      //     });
      //   },
      // },
    ];

    return isPressed
        ? GestureDetector(
            onTap: () {
              setState(() {
                isPressed = false;
              });
            },
            child: Container(
              color: Colors.black.withOpacity(0.6),
              alignment: Alignment.bottomRight,
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...floatingButtonList.map((floatingButton) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // shape: const CircleBorder(),
                                  elevation: 4,
                                  backgroundColor: MyTheme.green1,
                                ),
                                onPressed: floatingButton['onPressed'],
                                child: Container(
                                  // padding: const EdgeInsets.all(4),
                                  width: 100,
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(floatingButton['icon'], color: Colors.white, size: 28),
                                      Text(floatingButton['title'],
                                          style: const TextStyle(color: Colors.white, fontSize: 16))
                                    ],
                                  ),
                                )),
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
                padding: const EdgeInsets.only(bottom: 16, right: 16),
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

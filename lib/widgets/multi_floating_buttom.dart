import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/bottom_sheet/block_setting_bottom_sheet.dart';
import 'package:tumitas/widgets/bottom_sheet/bucket_setting_bottom_sheet.dart';
import 'package:tumitas/widgets/dialog/bucket_archive_dialog.dart';

class MultiFloatingBottom extends StatefulWidget {
  final Bucket? currentBucket;
  final Function(Map<String, dynamic>) onSetBucket;
  final Function(Block) onSetBlock;
  final Function() addArchive;

  const MultiFloatingBottom(
      {super.key,
      required this.onSetBucket,
      required this.onSetBlock,
      required this.currentBucket,
      required this.addArchive});

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

  void _handleAddArchive() {
    setState(() {
      widget.addArchive();
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
        'title': 'Block  ',
        'onPressed': () {
          setState(() {
            isPressed = false;
          });
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => BlockSettingBottomSheet(
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
        'icon': Icons.settings,
        'title': 'Bucket',
        'onPressed': () {
          setState(() {
            isPressed = false;
          });
          if (widget.currentBucket != null) {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) => BucketSettingBottomSheet(
                currentBucket: widget.currentBucket!,
                onSettingBucket: (Map<String, dynamic> settingBucketProperties) {
                  setState(() {
                    _handleSetBucket(settingBucketProperties);
                  });
                },
              ),
            );
          }
        },
      },
      {
        'icon': Icons.archive,
        'title': 'Archive',
        'onPressed': () {
          setState(() {
            isPressed = false;
          });
          if (widget.currentBucket != null) {
            showDialog(
                context: context,
                builder: (_) => BucketArchiveDialog(
                      addArchive: (bool isAddArchive) {
                        if (isAddArchive) {
                          setState(() {
                            _handleAddArchive();
                          });
                        }
                      },
                    ));
          }
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
              color: Colors.black.withOpacity(0.5),
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
                                  elevation: 4,
                                  backgroundColor: MyTheme.green1,
                                ),
                                onPressed: floatingButton['onPressed'],
                                child: SizedBox(
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

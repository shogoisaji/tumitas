import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/block_setting_dialog.dart';
import 'package:tumitas/widgets/bucket_setting_dialog.dart';

class MultiFloatingBottom extends StatefulWidget {
  final Function(Bucket) onSetBucket;
  final Function(Block) onSetBlock;

  const MultiFloatingBottom({super.key, required this.onSetBucket, required this.onSetBlock});

  @override
  State<MultiFloatingBottom> createState() => _MultiFloatingBottomState();
}

class _MultiFloatingBottomState extends State<MultiFloatingBottom> {
  bool isPressed = false;
  String nextBlockTitle = '';

  void _handleSetBucket(Bucket bucket) {
    setState(() {
      isPressed = false;
      widget.onSetBucket(bucket);
    });
  }

  void _handleSetBlock(Block block) {
    setState(() {
      widget.onSetBlock(block);
      print(block.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> floatingButtonList = [
      {
        'icon': Icons.note_alt,
        'onPressed': () {
          showDialog(
            context: context,
            builder: (_) => BlockSettingDialog(
              // TextEditingController(),
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
          showDialog(
            context: context,
            builder: (_) => BucketSettingDialog(
              TextEditingController(),
              onSettingBlock: (Block block) {
                setState(() {
                  // _handleSetBlock(block);
                });
              },
              onSettingBucket: _handleSetBucket,
            ),
          );
        },
      },
      {
        'icon': Icons.menu_book,
        'onPressed': () {
          setState(() {
            // isPressed = !isPressed;
          });
        },
      },
    ];

    return Padding(
        padding: const EdgeInsets.only(bottom: 6, right: 2),
        child: isPressed
            ? Column(
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
              )
            : FloatingActionButton(
                shape: const CircleBorder(),
                elevation: 4,
                backgroundColor: MyTheme.green1,
                onPressed: () {
                  setState(() {
                    isPressed = true;
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        isPressed = false;
                      });
                    });
                  });
                },
                child: const Icon(Icons.menu_book, color: Colors.white, size: 28),
              ));
  }
}

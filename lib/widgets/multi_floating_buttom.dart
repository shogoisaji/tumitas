import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/block_setting_dialog.dart';
import 'package:tumitas/widgets/bucket_setting_dialog.dart';

class MultiFloatingBottom extends StatefulWidget {
  final Function(String) onSubmittedText;
  final Function(Block) onSetBlock;

  const MultiFloatingBottom({super.key, required this.onSubmittedText, required this.onSetBlock});

  @override
  State<MultiFloatingBottom> createState() => _MultiFloatingBottomState();
}

class _MultiFloatingBottomState extends State<MultiFloatingBottom> {
  bool isPressed = false;
  String nextBlockTitle = '';

  void _handleSubmitted(String newTitle) {
    setState(() {
      isPressed = false;
      widget.onSubmittedText(newTitle);
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
          showDialog(
            context: context,
            builder: (_) => BlockSettingDialog(
              TextEditingController(),
              onSetting: (Block block) {
                setState(() {
                  _handleSetBlock(block);
                });
              },
              onSubmitted: _handleSubmitted,
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
              onSetting: (Block block) {
                setState(() {
                  _handleSetBlock(block);
                });
              },
              onSubmitted: _handleSubmitted,
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

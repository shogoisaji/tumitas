import 'package:flutter/material.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/task_title_dialog.dart';

class MultiFloatingBottom extends StatefulWidget {
  final Function(String) onSubmittedText;

  const MultiFloatingBottom({super.key, required this.onSubmittedText});

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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> floatingButtonList = [
      {
        'icon': Icons.note_alt,
        'onPressed': () {
          showDialog(
            context: context,
            builder: (_) => TaskTitleDialog(
              TextEditingController(),
              onSubmitted: _handleSubmitted,
            ),
          );
        },
      },
      {
        'icon': Icons.change_circle,
        'onPressed': () {},
      },
      {
        'icon': Icons.arrow_back,
        'onPressed': () {
          setState(() {
            isPressed = !isPressed;
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

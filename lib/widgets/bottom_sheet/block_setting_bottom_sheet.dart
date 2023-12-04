import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/theme/theme.dart';

class BlockSettingBottomSheet extends StatefulWidget {
  final Function(Block) onSetting;

  const BlockSettingBottomSheet({
    super.key,
    required this.onSetting,
  });

  @override
  State<BlockSettingBottomSheet> createState() => _BlockSettingBottomSheetState();
}

class _BlockSettingBottomSheetState extends State<BlockSettingBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  final Color contentFillColor = MyTheme.grey2;
  BlockType _selectedBlockType = BlockType.block1x1;
  int _selectedColorIndex = 0;

  FocusNode focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double sheetHeight = 550;
    return Container(
      height: sheetHeight,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: MyTheme.green5,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )),
      child: Column(children: [
        const SizedBox(
          height: 24,
        ),
        TextField(
          controller: _textController,
          focusNode: focusNode,
          decoration: InputDecoration(
            suffixIcon: isFocused
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                      });
                    },
                    child: const Icon(Icons.keyboard_return, color: MyTheme.grey1),
                  )
                : null,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(color: MyTheme.grey1, width: 1),
            ),
            labelText: 'Task Title',
            labelStyle: const TextStyle(color: MyTheme.grey1),
            fillColor: contentFillColor,
            filled: true,
          ),
        ),
        Container(
            decoration: BoxDecoration(
              color: contentFillColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: MyTheme.grey1, width: 1),
            ),
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < BlockType.values.length; i++)
                    Padding(
                      padding: i != BlockType.values.length - 1
                          ? const EdgeInsets.only(left: 12.0)
                          : const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: _selectedBlockType == BlockType.values[i]
                                  ? Border.all(color: Colors.black54, width: 3)
                                  : Border.all(color: Colors.transparent, width: 3),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedBlockType = BlockType.values[i];
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              child: Align(
                                child: Container(
                                  width: BlockType.values[i].blockSize.x * 30,
                                  height: BlockType.values[i].blockSize.y * 30,
                                  decoration: BoxDecoration(
                                    color: blockColorList[_selectedColorIndex],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${BlockType.values[i].blockSize.x}x${BlockType.values[i].blockSize.y}',
                              style: const TextStyle(color: MyTheme.grey1, fontSize: 16)),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                ],
              ),
            )),
        Container(
          decoration: BoxDecoration(
            color: contentFillColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: MyTheme.grey1, width: 1),
          ),
          height: 160,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: blockColorList.length,
            itemBuilder: (context, index) {
              return Align(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: _selectedColorIndex == index ? Border.all(color: Colors.black54, width: 3) : null,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColorIndex = index;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    child: Container(
                      width: 35,
                      decoration: BoxDecoration(
                        color: blockColorList[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text('Cancel', style: TextStyle(color: MyTheme.green1, fontSize: 22)),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                widget.onSetting(Block(
                    blockColorList[_selectedColorIndex], _textController.text, "", _selectedBlockType, DateTime.now()));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: MyTheme.green1,
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
            ),
          ],
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/theme/theme.dart';

class BlockSettingDialog extends StatefulWidget {
  // final TextEditingController _textController;
  final Function(Block) onSetting;

  const BlockSettingDialog({Key? key, required this.onSetting}) : super(key: key);

  @override
  State<BlockSettingDialog> createState() => _BlockSettingDialogState();
}

class _BlockSettingDialogState extends State<BlockSettingDialog> {
  TextEditingController _textController = TextEditingController();
  final Color fillColor = MyTheme.grey3;
  BlockType _selectedBlockType = BlockType.block1x1;
  int _selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Task Settings',
          style: TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 32)),
      backgroundColor: MyTheme.green5,
      content: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          height: 380,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: MyTheme.grey1, width: 1),
                  ),
                  labelText: 'Task Title',
                  labelStyle: const TextStyle(color: MyTheme.grey1),
                  fillColor: fillColor,
                  filled: true,
                ),
                maxLines: 2,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: fillColor,
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
                  color: fillColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: MyTheme.grey1, width: 1),
                ),
                // height: 130,
                constraints: const BoxConstraints(maxHeight: 130),
                height: MediaQuery.of(context).size.width * 0.3,
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
                            });
                          },
                          child: Container(
                            width: 30,
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
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: Colors.white,
          ),
          child: const Text('Cancel', style: TextStyle(color: MyTheme.green1)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSetting(Block(blockColorList[_selectedColorIndex], _textController.text, "", _selectedBlockType));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: MyTheme.green1,
          ),
          child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ),
      ],
    );
  }
}

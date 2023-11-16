import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';

class BlockTypeDropdownWidget extends StatefulWidget {
  final Function(BlockType?) onSelected;
  const BlockTypeDropdownWidget({
    super.key,
    required this.onSelected,
  });

  @override
  _WordsCountDropdownWidgetState createState() =>
      _WordsCountDropdownWidgetState();
}

class _WordsCountDropdownWidgetState extends State<BlockTypeDropdownWidget> {
  BlockType selectedType = BlockType.block1x1;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<BlockType>(
      value: selectedType,
      onChanged: (BlockType? newValue) {
        setState(() {
          selectedType = newValue!;
        });
        widget.onSelected(newValue);
      },
      items:
          BlockType.values.map<DropdownMenuItem<BlockType>>((BlockType type) {
        return DropdownMenuItem<BlockType>(
          value: type,
          child: Center(child: Text(type.toString().split('block')[1])),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tumitas/models/block.dart';

class BlockTypeDropdownWidget extends StatefulWidget {
  final BlockType initValue;
  final Function(BlockType?) onSelected;
  const BlockTypeDropdownWidget({
    super.key,
    required this.initValue,
    required this.onSelected,
  });

  @override
  State<BlockTypeDropdownWidget> createState() => _BlockTypeDropdownWidgetState();
}

class _BlockTypeDropdownWidgetState extends State<BlockTypeDropdownWidget> {
  late BlockType selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initValue;
  }

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
      items: BlockType.values.map<DropdownMenuItem<BlockType>>((BlockType type) {
        return DropdownMenuItem<BlockType>(
          value: type,
          child: Center(child: Text(type.toString().split('block')[1])),
        );
      }).toList(),
    );
  }
}

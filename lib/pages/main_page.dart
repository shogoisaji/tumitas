import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/widgets/block_type_dropdown.dart';
import 'package:tumitas/widgets/block_widget.dart';
import 'package:tumitas/widgets/bucket_widget.dart';
import 'package:tumitas/widgets/task_title_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

Block nextBlock = BlockType.block1x1.block;
Bucket bucket = Bucket(color: Colors.grey, bucketSize: BucketSize(5, 10));

class _MainPageState extends State<MainPage> {
  TextEditingController _textController = TextEditingController();
  String taskTitle = '';
  double nextBlockPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  BlockType? selectedBlockType;

  void _onBlockTypeSelected(BlockType? type) {
    setState(() {
      selectedBlockType = type;
      if (type != null) {
        nextBlock = type.block;
      }
    });
  }

  void _handleSubmitted(String newTitle) {
    setState(() {
      taskTitle = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red[200],
                    child: Stack(children: [
                      Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, bottom: 20.0),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: bucket.bucketSize.x *
                                              oneBlockSize,
                                          height: nextBlock.blockSize.y *
                                              oneBlockSize,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: bucket.bucketSize.x +
                                                (1 - nextBlock.blockSize.x),
                                            itemBuilder: (context, index) {
                                              return DragTarget(
                                                onAccept: (data) {
                                                  setState(() {
                                                    nextBlockPosition =
                                                        index * oneBlockSize;
                                                  });
                                                },
                                                builder: (context,
                                                        candidateData,
                                                        rejectedData) =>
                                                    Container(
                                                  width: oneBlockSize,
                                                  height:
                                                      nextBlock.blockSize.y *
                                                          oneBlockSize,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: nextBlockPosition),
                                      child: Draggable(
                                          data: 1,
                                          axis: Axis.horizontal,
                                          childWhenDragging: Container(),
                                          feedback: Material(
                                              child: BlockWidget(nextBlock,
                                                  taskTitle: taskTitle)),
                                          child: BlockWidget(nextBlock,
                                              taskTitle: taskTitle)),
                                    ),
                                  ],
                                ),
                              ),
                              BucketWidget(bucket),
                            ],
                          ))
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
              width: 250,
              color: Colors.green[200],
              child: Row(
                children: [
                  BlockTypeDropdownWidget(
                    onSelected: _onBlockTypeSelected,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => TaskTitleDialog(
                            TextEditingController(text: taskTitle),
                            onSubmitted: _handleSubmitted,
                          ),
                        );
                      },
                      child:
                          const Text('Task', style: TextStyle(fontSize: 20))),
                  ElevatedButton(
                      onPressed: () {
                        bucket.getMaxPosition();
                      },
                      child:
                          const Text('test', style: TextStyle(fontSize: 20))),
                ],
              )),
        ],
      ),
    );
  }
}

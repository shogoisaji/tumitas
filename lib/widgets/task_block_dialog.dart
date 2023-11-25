import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/block.dart';
import 'package:tumitas/theme/theme.dart';

class TaskBlockDialog extends StatefulWidget {
  final TextEditingController _textController;
  final Function(String) onSubmitted;

  const TaskBlockDialog(this._textController, {Key? key, required this.onSubmitted}) : super(key: key);

  @override
  _TaskBlockDialogState createState() => _TaskBlockDialogState();
}

class _TaskBlockDialogState extends State<TaskBlockDialog> {
  BlockType _selectedBlockType = BlockType.block1x1;
  int _selectedColorIndex = 0;
  List<Color> randomColorList = [];

  // void setRandomColorList() {
  //   int rand = Random().nextInt(blockColorList.length);
  //   for (int i = 0; i < BlockType.values.length; i++) {
  //     int newColorIndex = (i + rand) % blockColorList.length;
  //     randomColorList.add(blockColorList[newColorIndex]);
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   setRandomColorList();
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Task Settings'),
      backgroundColor: MyTheme.green5,
      content: Container(
        // color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            TextField(
              controller: widget._textController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                labelText: 'Task Title',
                fillColor: Colors.white,
                filled: true,
              ),
              maxLines: 2,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16),
              child: PageView.builder(
                controller: PageController(initialPage: 1, viewportFraction: 0.45),
                itemCount: BlockType.values.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100 * index],
                          borderRadius: BorderRadius.circular(10),
                          border: _selectedBlockType == BlockType.values[index]
                              ? Border.all(color: Colors.black54, width: 3)
                              : null,
                        ),
                        padding: const EdgeInsets.all(3),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedBlockType = BlockType.values[index];
                            });
                          },
                          child: Align(
                            child: Container(
                              width: BlockType.values[index].blockSize.x * 30,
                              height: BlockType.values[index].blockSize.y * 30,
                              decoration: BoxDecoration(
                                color: blockColorList[_selectedColorIndex],
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${BlockType.values[index].blockSize.x}x${BlockType.values[index].blockSize.y}'),
                      const SizedBox(height: 6),
                    ],
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              height: 115,
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
                          // height: 30,
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
            // onSubmitted(_textController.text);
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
//   final TextEditingController _textController;
//   final Function(String) onSubmitted;
  
//   const TaskBlockDialog(this._textController, {Key? key, required this.onSubmitted}) : super(key: key);


//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       // icon: const Icon(
//       //   Icons.note_alt_outlined,
//       //   size: 28,
//       // ),
//       title: const Text('Task Settings'),
//       // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//       backgroundColor: MyTheme.green5,
//       content: Container(
//         color: Colors.white,
//         width: MediaQuery.of(context).size.width * 0.8,
//         // constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
//         child: Column(
//           children: [
//             TextField(
//               controller: _textController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Task',
//               ),
//               maxLines: 2,
//             ),
//             SizedBox(
//                 height: 100,
//                 width: double.infinity,
//                 child: PageView.builder(
//                   controller: PageController(viewportFraction: 0.5),
//                   itemCount: BlockType.values.length,
//                   itemBuilder: (context, index) {
//                     return Align(
//                       child: Container(
//                         width: BlockType.values[index].blockSize.x * 30,
//                         height: BlockType.values[index].blockSize.y * 30,
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     );
//                   },
//                 )),
//           ],
//         ),
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: () => Navigator.pop(context),
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8),
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             backgroundColor: Colors.white,
//           ),
//           child: const Text('Cancel', style: TextStyle(color: MyTheme.green1)),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             onSubmitted(_textController.text);
//             Navigator.pop(context);
//           },
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8),
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             backgroundColor: MyTheme.green1,
//           ),
//           child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
//         ),
//       ],
//     );
//   }
// }

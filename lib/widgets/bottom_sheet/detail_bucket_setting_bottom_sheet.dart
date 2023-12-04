import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/theme/theme.dart';

class DetailBucketSettingBottomSheet extends StatefulWidget {
  final Bucket selectedBucket;
  final Function(Map<String, dynamic>) onSettingDetailPageBucket;
  final Function(String) deleteBucket;

  const DetailBucketSettingBottomSheet({
    super.key,
    required this.selectedBucket,
    required this.onSettingDetailPageBucket,
    required this.deleteBucket,
  });

  @override
  State<DetailBucketSettingBottomSheet> createState() => _DetailBucketSettingBottomSheetState();
}

class _DetailBucketSettingBottomSheetState extends State<DetailBucketSettingBottomSheet> {
  late TextEditingController _textController;
  final Color contentFillColor = MyTheme.grey2;
  int _selectedInnerColorIndex = 0;
  int _selectedOuterColorIndex = 0;

  FocusNode focusNode = FocusNode();
  bool isFocused = false;

  void setTodayText() {
    DateTime now = DateTime.now();
    _textController.text = DateFormat('yyyy.MM.dd').format(now);
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.selectedBucket.bucketTitle);
    _selectedInnerColorIndex = bucketInnerColorList.indexOf(widget.selectedBucket.bucketInnerColor);
    _selectedOuterColorIndex = bucketOuterColorList.indexOf(widget.selectedBucket.bucketOuterColor);
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
    final double sheetHeight = 450 + MediaQuery.of(context).viewInsets.bottom / 3.5;
    return Container(
      height: sheetHeight,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: MyTheme.green5,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )),
      child: Column(
        children: [
          const Text('Setting Bucket',
              style: TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 28)),
          const SizedBox(height: 16),
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
                  : GestureDetector(
                      onTap: () {
                        setTodayText();
                      },
                      child: const Icon(Icons.calendar_today, color: MyTheme.grey1),
                    ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: MyTheme.grey1, width: 1),
              ),
              labelText: 'Bucket Setting',
              labelStyle: const TextStyle(color: MyTheme.grey1),
              fillColor: contentFillColor,
              filled: true,
            ),
          ),
          // bucket inner color
          Container(
              decoration: BoxDecoration(
                color: contentFillColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: MyTheme.grey1, width: 1),
              ),
              height: 75,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0, bottom: 4),
                    child: Text('Inner Color', style: TextStyle(color: MyTheme.grey1, fontSize: 16)),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < bucketInnerColorList.length; i++)
                          Padding(
                            padding: i != bucketInnerColorList.length - 1
                                ? const EdgeInsets.only(left: 12.0)
                                : const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: _selectedInnerColorIndex == i
                                        ? Border.all(color: Colors.black54, width: 3)
                                        : Border.all(color: Colors.transparent, width: 3),
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedInnerColorIndex = i;
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    child: Align(
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: bucketInnerColorList[i],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )),
          // bucket outer color
          Container(
              decoration: BoxDecoration(
                color: contentFillColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: MyTheme.grey1, width: 1),
              ),
              height: 75,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0, bottom: 4),
                    child: Text('Outer Color', style: TextStyle(color: MyTheme.grey1, fontSize: 16)),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < bucketOuterColorList.length; i++)
                          Padding(
                            padding: i != bucketOuterColorList.length - 1
                                ? const EdgeInsets.only(left: 12.0)
                                : const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: _selectedOuterColorIndex == i
                                        ? Border.all(color: Colors.black54, width: 3)
                                        : Border.all(color: Colors.transparent, width: 3),
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedOuterColorIndex = i;
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    child: Align(
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: bucketOuterColorList[i],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Bucket',
                              style: TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 32)),
                          backgroundColor: MyTheme.green5,
                          content: const Text('本当に削除しますか？', style: TextStyle(color: MyTheme.grey1, fontSize: 22)),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text('Cancel',
                                  style: TextStyle(color: MyTheme.green1, fontWeight: FontWeight.bold, fontSize: 20)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.deleteBucket(widget.selectedBucket.bucketId);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                backgroundColor: Colors.red[400],
                              ),
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                            ),
                          ],
                        );
                      },
                    );
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: Colors.red[400],
                ),
                child: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 22)),
              ),
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
                      Map<String, dynamic> settingBucketProperties = {
                        'title': _textController.text,
                        'innerColor': bucketInnerColorList[_selectedInnerColorIndex],
                        'outerColor': bucketOuterColorList[_selectedOuterColorIndex],
                      };
                      widget.onSettingDetailPageBucket(settingBucketProperties);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      backgroundColor: MyTheme.green1,
                    ),
                    child: const Text('OK',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/theme/theme.dart';

class BucketRegistrationBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onRegisterBucket;

  const BucketRegistrationBottomSheet({super.key, required this.onRegisterBucket});

  @override
  State<BucketRegistrationBottomSheet> createState() => _BucketRegistrationBottomSheetState();
}

class _BucketRegistrationBottomSheetState extends State<BucketRegistrationBottomSheet> {
  final TextEditingController _textController = TextEditingController();
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
          const Text('New Bucket', style: TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 28)),
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
                        setState(() {});
                      },
                      child: const Icon(Icons.calendar_today, color: MyTheme.grey1),
                    ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: MyTheme.grey1, width: 1),
              ),
              labelText: 'Bucket Title',
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
              _textController.text != ''
                  ? ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> settingBucketProperties = {
                          'title': _textController.text,
                          'innerColor': bucketInnerColorList[_selectedInnerColorIndex],
                          'outerColor': bucketOuterColorList[_selectedOuterColorIndex],
                        };
                        widget.onRegisterBucket(settingBucketProperties);
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
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        backgroundColor: MyTheme.disableButton,
                      ),
                      child: const Text('OK',
                          style: TextStyle(color: Colors.black12, fontWeight: FontWeight.bold, fontSize: 22)),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

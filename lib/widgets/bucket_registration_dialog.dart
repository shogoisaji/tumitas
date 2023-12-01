import 'package:flutter/material.dart';
import 'package:tumitas/config/config.dart';
import 'package:tumitas/theme/theme.dart';

class BucketRegistrationDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onRegisterBucket;

  const BucketRegistrationDialog({Key? key, required this.onRegisterBucket}) : super(key: key);

  @override
  State<BucketRegistrationDialog> createState() => _BucketRegistrationDialogState();
}

class _BucketRegistrationDialogState extends State<BucketRegistrationDialog> {
  late TextEditingController _textController;
  final Color contentFillColor = MyTheme.grey3;
  int _selectedInnerColorIndex = 0;
  int _selectedOuterColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bucket Registration',
          style: TextStyle(color: MyTheme.grey1, fontWeight: FontWeight.bold, fontSize: 32)),
      backgroundColor: MyTheme.green5,
      content: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          height: 250,
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
                        padding: EdgeInsets.only(left: 12.0, bottom: 2),
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
                                        // borderRadius: BorderRadius.circular(10),
                                        border: _selectedInnerColorIndex == i
                                            ? Border.all(color: Colors.black54, width: 3)
                                            : Border.all(color: Colors.transparent, width: 3),
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedInnerColorIndex = i;
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
                        padding: EdgeInsets.only(left: 12.0, bottom: 2),
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
                                        // borderRadius: BorderRadius.circular(10),
                                        border: _selectedOuterColorIndex == i
                                            ? Border.all(color: Colors.black54, width: 3)
                                            : Border.all(color: Colors.transparent, width: 3),
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedOuterColorIndex = i;
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
            Map<String, dynamic> settingBucketProperties = {
              'title': _textController.text,
              'innerColor': bucketInnerColorList[_selectedInnerColorIndex],
              'outerColor': bucketOuterColorList[_selectedOuterColorIndex],
            };
            widget.onRegisterBucket(settingBucketProperties);
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

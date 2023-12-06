import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tumitas/models/block.dart';

class BlockWidget extends StatelessWidget {
  final Block block;
  final double titleFontSize = 14;
  final double oneBlockSize;
  const BlockWidget(
    this.block,
    this.oneBlockSize, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = oneBlockSize / 7;

    String formatDate(String dateStr) {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat('MM.dd').format(dateTime);
    }

    return Container(
        width: block.blockType.blockSize.x * oneBlockSize,
        height: block.blockType.blockSize.y * oneBlockSize,
        padding: const EdgeInsets.all(2.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: block.color,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.5,
                blurRadius: 1.0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: oneBlockSize > 30
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            block.title,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: block.blockType.blockSize.y * 2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 2),
                      child: Text(
                        formatDate(block.blockRegisterDate.toIso8601String()),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ))
              : Container(),
        ));
  }
}

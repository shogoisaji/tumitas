import 'package:flutter/material.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/pages/detail_page.dart';
import 'package:tumitas/services/sqflite_helper.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

Future<List<Bucket>> loadAllBucket() async {
  final List<Bucket> bucketList = await SqfliteHelper.instance.fetchArchiveBucket();
  print('loadAllBucket: length ${bucketList.length}');
  return bucketList;
}

class _ArchivePageState extends State<ArchivePage> {
  final double oneBlockSize = 25;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: FutureBuilder<List<Bucket>>(
              future: loadAllBucket(),
              builder: (BuildContext context, AsyncSnapshot<List<Bucket>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                } else if (snapshot.hasData) {
                  final List<Bucket> bucketList = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: bucketList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  DetailPage(snapshot.data![index]),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                var tween = Tween<double>(begin: 0.0, end: 1.0);
                                var fadeAnimation = animation.drive(tween);

                                return FadeTransition(
                                  opacity: fadeAnimation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 200),
                            ),
                          );
                        },
                        child: BucketWidget(
                          snapshot.data![index],
                          oneBlockSize,
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No Data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

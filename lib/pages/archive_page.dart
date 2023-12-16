import 'package:flutter/material.dart';
import 'package:tumitas/animations/archive_band_slide_animation.dart';
import 'package:tumitas/animations/archive_text_slide_animation.dart';
import 'package:tumitas/models/bucket.dart';
import 'package:tumitas/pages/detail_page.dart';
import 'package:tumitas/services/sqflite_helper.dart';
import 'package:tumitas/theme/theme.dart';
import 'package:tumitas/widgets/bucket_widget.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

Future<List<Bucket>> loadAllBucket() async {
  final List<Bucket> bucketList = await SqfliteHelper.instance.fetchArchiveBucket();
  return bucketList;
}

class _ArchivePageState extends State<ArchivePage> with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late AnimationController _bandAnimationController;
  late CurvedAnimation bandCurvedAnimation;

  @override
  void initState() {
    super.initState();

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _bandAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    bandCurvedAnimation = CurvedAnimation(
      parent: _bandAnimationController,
      curve: Curves.easeIn,
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      _bandAnimationController.forward();
    });
    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _bandAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double oneBlockSize = MediaQuery.of(context).size.width / 15;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Stack(
        children: [
          Column(
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
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: bucketList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              _bandAnimationController.forward(from: 1.0);
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
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                color: MyTheme.grey2,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1.5,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: BucketWidget(
                                      snapshot.data![index],
                                      oneBlockSize,
                                    ),
                                  ),
                                  Container(color: Colors.transparent)
                                ],
                              ),
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
          ArchiveBandSlideAnimation(
            animation: bandCurvedAnimation,
            child: Transform.translate(
              offset: const Offset(80, 50),
              child: Transform.rotate(
                angle: 0.5,
                child: Transform.scale(
                  scale: 1.5,
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 50,
                    width: 1000,
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: BorderSide(width: 3, color: Colors.white),
                        top: BorderSide(width: 3, color: Colors.white),
                      ),
                      color: MyTheme.deepSkyBlue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: ArchiveTextSlideAnimation(
                      animationController: _textAnimationController,
                      child: const Text('Archive',
                          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

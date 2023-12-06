import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tumitas/pages/archive_page.dart';
import 'package:tumitas/pages/play_page.dart';
import 'package:tumitas/services/shared_preferences_helper.dart';
import 'package:tumitas/theme/theme.dart';

void main() async {
  runApp(const MyApp());
  await SharedPreferencesHelper.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final pageController = PageController();
  int currentIndex = 0;

  List<Map<String, dynamic>> bottomNavigationBarItems = [
    {
      'icon': const FaIcon(
        FontAwesomeIcons.cube,
        size: 28,
      ),
      'page': const PlayPage(),
    },
    {
      'icon': const FaIcon(
        FontAwesomeIcons.boxArchive,
        size: 28,
      ),
      'page': const ArchivePage()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 32,
          selectedItemColor: Colors.white,
          unselectedItemColor: MyTheme.green4,
          backgroundColor: MyTheme.green1,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
            });
          },
          items: [
            ...bottomNavigationBarItems
                .map((e) => BottomNavigationBarItem(
                    icon: Column(
                      children: [
                        e['icon'],
                        if (currentIndex == bottomNavigationBarItems.indexOf(e))
                          Container(
                            width: 24,
                            height: 3,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(3),
                              ),
                            ),
                          )
                      ],
                    ),
                    label: ''))
                .toList(),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [MyTheme.blue1, MyTheme.green5],
            ),
          ),
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...bottomNavigationBarItems.map((e) => e['page']).toList(),
            ],
          ),
        ));
  }
}

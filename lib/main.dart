import 'package:flutter/material.dart';
import 'package:r_sdk_m/growth_book.dart';
import 'package:r_sdk_m/src/Utils/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<String> tabNames = <String>[
    'All',
    'Travel',
    'Lifestyle',
    'Fitness',
    'Education',
    'Elections',
    'Original',
    'World',
    'Travel'
  ];
  late List<Tab> tabs;

  /// Initialization of controllers.
  late TabController _tabController;
  final userAttr = {
    Constant.idAttribute: '12',
  };
  late final GrowthBookSDK gb;
  @override
  void initState() {
    _tabController = TabController(length: tabNames.length, vsync: this);
    tabs = <Tab>[
      ...tabNames
          .map((e) => Tab(
                text: e,
              ))
          .toList()
    ];

    /// Initializing SDK.
    gb = GBSDKBuilderApp(
            apiKey: 'key_prod_284897d8a1c89689',
            hostURL:
                'http://a2c0156b9af934bcaa8f539de1928e85-2035136552.ap-south-1.elb.amazonaws.com:3100/',
            attributes: userAttr,
            growthBookTrackingCallBack: (experiment, experimentResult) {
              /// Track feature.
            })
        .initialize()
      ..afterFetch = () {
        setState(() {});
      };
    super.initState();
  }

  Widget _getRightWidget() {
    if (gb.feature('tab_feature').on!) {
      return TabBar(
        isScrollable: true,
        tabs: tabs,
        controller: _tabController,
        indicator: CircleTabIndicator(
          color: Theme.of(context).colorScheme.primary,
          radius: 4,
        ),
      );
    } else {
      return TabBar(
        isScrollable: true,
        tabs: tabs,
        controller: _tabController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _getRightWidget(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (var i = 0; i < tabNames.length; i++)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(tabNames[i]),
                          ElevatedButton(
                              onPressed: () {
                                print(gb.feature('tab_feature').on);
                              },
                              child: const Text('Press'))
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//// To create dot shaped indicator.
class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = false;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
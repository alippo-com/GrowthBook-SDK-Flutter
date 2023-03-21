import 'package:flutter/material.dart';
import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

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

class _HomeState extends State<Home> {
  late final GBSDKBuilderApp gbApp;
  late final GrowthBookSDK gb;

  @override
  void initState() {
    initializeSDK();
    super.initState();
  }

  void initializeSDK() async {
    const apiKey = String.fromEnvironment('GROWTHBOOK_API_KEY');
    const apiHost = String.fromEnvironment('GROWTHBOOK_API_HOST');

    gbApp = GBSDKBuilderApp(
      apiKey: apiKey,
      hostURL: apiHost,
      attributes: null,
      growthBookTrackingCallBack: (exp, rst) {
        debugPrint('Tracking: ${exp.toString()} and ${rst.toString()}');
      },
    );
  }

  @override
  void didChangeDependencies() async {
    final gbInitialized = await gbApp.initialize();
    setState(() {
      gb = gbInitialized;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrowthBook SDK'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Set Attribute'),
            onTap: () {
              gb.setAttributes({
                'id': 'foo',
              });
            },
          ),
          ListTile(
            title: const Text('Get All Feature'),
            onTap: () {
              final features = gb.features;
              debugPrint('Features: ${features.toString()}');
            },
          ),
          ListTile(
            title: const Text('Get Feature'),
            onTap: () {
              final feature = gb.feature('your-feature-id');
              debugPrint('Feature config-test: ${feature.toString()}');
            },
          ),
          ListTile(
            title: const Text('Refresh'),
            onTap: () => gb.refresh(),
          ),
        ],
      ),
    );
  }
}

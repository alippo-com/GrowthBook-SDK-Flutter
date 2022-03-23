import 'package:flutter/material.dart';
import 'package:r_sdk_m/growth_book.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userAttr = {'Name': 'Dhruvin'};

  late final GrowthBookSDK gb;
  @override
  void initState() {
    /// Initializing SDK.
    gb = GBSDKBuilderApp(
            apiKey: 'key_dev_48ecac96a7facd6c',
            hostURL: 'https://cdn.growthbook.io/',
            attributes: userAttr,
            growthBookTrackingCallBack: (experiment, experimentResult) {
              /// Track feature.
            })
        .initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rocking features',
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                /// Check features from growth_book by [GrowthBookSDK.context..]
                ///
              },
              child: const Text('List Down All Features'),
            )
          ],
        ),
      ),
    );
  }
}

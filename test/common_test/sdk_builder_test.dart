import 'package:flutter_test/flutter_test.dart';
import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

import '../mocks/network_mock.dart';

void main() {
  group('Initialization', () {
    const testApiKey = '<API_KEY>';
    const attr = <String, String>{};
    const testHostURL = 'https://example.growthbook.io/';
    const client = MockNetworkClient();
    test("- default", () async {
      final sdk = await GBSDKBuilderApp(
        apiKey: testApiKey,
        hostURL: testHostURL,
        attributes: attr,
        client: client,
        growthBookTrackingCallBack: (experiment, experimentResult) {},
      ).initialize();

      /// Test API key
      expect(sdk.context.apiKey, testApiKey);

      /// Feature mode
      expect(sdk.context.enabled, true);

      /// Test HostUrl
      expect(sdk.context.hostURL, testHostURL);

      /// Test qaMode
      expect(sdk.context.qaMode, false);

      /// Test passed attr.
      expect(sdk.context.attributes, attr);
    });

    test('- with pre set data', () async {
      const variations = <String, int>{};

      final sdk = await GBSDKBuilderApp(
              apiKey: testApiKey,
              qaMode: true,
              client: client,
              forcedVariations: variations,
              hostURL: testHostURL,
              attributes: attr,
              growthBookTrackingCallBack: (exp, result) {})
          .initialize();
      expect(sdk.context.enabled, true);
      expect(sdk.context.qaMode, true);
    });

    test('- with network client', () async {
      GrowthBookSDK sdk = await GBSDKBuilderApp(
              apiKey: testApiKey,
              hostURL: testHostURL,
              attributes: attr,
              client: client,
              growthBookTrackingCallBack: (exp, result) {})
          .initialize();
      final featureValue = sdk.feature('fwrfewrfe');
      expect(featureValue.source, GBFeatureSource.unknownFeature);

      final result = sdk.run(GBExperiment(key: "fwrfewrfe"));
      expect(result.variationID, 0);
    });

    test('- with initialization assertion', () async {
      expect(
        () => GBSDKBuilderApp(
          apiKey: testApiKey,
          hostURL: "https://example.growthbook.io",
          client: client,
          growthBookTrackingCallBack: (_, __) {},
        ),
        throwsAssertionError,
      );
    });
  });
}

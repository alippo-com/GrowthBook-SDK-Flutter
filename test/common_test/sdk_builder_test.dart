import 'package:dio/dio.dart';
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

    test('- qa mode', () async {
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

    test('- with initialization assertion cause of wrong host url', () async {
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

    test(
      '- with failed network client',
      () async {
        GrowthBookSDK sdk = await GBSDKBuilderApp(
          apiKey: testApiKey,
          hostURL: testHostURL,
          attributes: attr,
          client: const MockNetworkClient(error: true),
          growthBookTrackingCallBack: (exp, result) {},
          gbFeatures: {'some-feature': GBFeature(defaultValue: true)},
        ).initialize();
        final featureValue = sdk.feature('some-feature');
        expect(featureValue.value, true);

        final result = sdk.run(GBExperiment(key: "some-feature"));
        expect(result.variationID, 0);
      },
    );

    test(
      '- onInitializationFailure callback test',
      () async {
        GBError? error;

        await GBSDKBuilderApp(
          apiKey: testApiKey,
          hostURL: testHostURL,
          attributes: attr,
          client: const MockNetworkClient(error: true),
          growthBookTrackingCallBack: (exp, result) {},
          gbFeatures: {'some-feature': GBFeature(defaultValue: true)},
          onInitializationFailure: (e) => error = e,
        ).initialize();

        expect(error != null, true);
        expect(error?.error is DioException, true);
        expect(error?.stackTrace != null, true);
      },
    );
  });
}

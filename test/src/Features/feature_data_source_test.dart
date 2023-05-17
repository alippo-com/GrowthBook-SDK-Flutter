import 'package:flutter_test/flutter_test.dart';
import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

class _MockError extends Error {}

class _MockFailingNetworkClient implements BaseClient {
  const _MockFailingNetworkClient();
  @override
  Future<Map<String, dynamic>> consumeGetRequest(String path) {
    throw _MockError();
  }
}

void main() {
  group('FeatureDataSource', () {
    group('featureFeatures', () {
      test('propogates thrown errors from the client', () async {
        const testApiKey = '<SOME KEY>';
        const attr = <String, String>{};
        const testHostURL = '<HOST URL>';
        final context = GBContext(
          apiKey: testApiKey,
          hostURL: testHostURL,
          attributes: attr,
          enabled: true,
          forcedVariation: {},
          qaMode: false,
          trackingCallBack: (_, __) {},
        );

        bool onErrorHappened = false;

        final featureDataSource = FeatureDataSource(
            context: context, client: const _MockFailingNetworkClient());

        try {
          await featureDataSource.fetchFeatures();
        } on _MockError catch (_) {
          onErrorHappened = true;
        }

        expect(onErrorHappened, true);
      });
    });
  });
}

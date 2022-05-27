import 'package:flutter_test/flutter_test.dart';
import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

import '../mocks/network_mock.dart';
import '../mocks/network_view_model_mock.dart';

void main() {
  group('Feature viewModel group test', () {
    late FeatureViewModel featureViewModel;
    late DataSourceMock dataSourceMock;
    late GBContext context;
    const testApiKey = 'key_prod_284897d8a1c89689';
    const attr = <String, String>{};
    const testHostURL =
        'http://a2c0156b9af934bcaa8f539de1928e85-2035136552.ap-south-1.elb.amazonaws.com:3100/';

    setUp(() {
      context = GBContext(
        apiKey: testApiKey,
        hostURL: testHostURL,
        attributes: attr,
        enabled: true,
        forcedVariation: {},
        qaMode: false,
        trackingCallBack: (_, __) {},
      );
      dataSourceMock = DataSourceMock();
      featureViewModel = FeatureViewModel(
        delegate: dataSourceMock,
        source: FeatureDataSource(
            client: MockNetworkClient(), context: context, onError: (e, s) {}),
      );
    });
    test('success feature-view model.', () async {
      await featureViewModel.fetchFeature();
      expect(dataSourceMock.isSuccess, true);
    });
  });
}

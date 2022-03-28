import 'package:flutter_test/flutter_test.dart';
import 'package:r_sdk_m/src/Features/feature_data_source.dart';
import 'package:r_sdk_m/src/Features/features_view_model.dart';
import 'package:r_sdk_m/src/model/context.dart';

import '../Mocks/network_mock.dart';
import '../Mocks/network_viewmodel_mock.dart';

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
        source:
            FeatureDataSource(client: MockNetworkClient(), context: context),
      );
    });
    test('success feature-view model.', () async {
      await featureViewModel.fetchFeature();
      expect(dataSourceMock.isSuccess, true);
    });
  });
}

import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

typedef FeatureFetchSuccessCallBack = void Function(
  FeaturedDataModel featuredDataModel,
);

abstract class FeaturesFlowDelegate {
  void featuresFetchedSuccessfully(GBFeatures gbFeatures);
  void featuresFetchFailed(GBError? error);
}

class FeatureDataSource {
  FeatureDataSource({
    required this.context,
    required this.client,
  });
  final GBContext context;
  final BaseClient client;

  Future<void> fetchFeatures(
      FeatureFetchSuccessCallBack onSuccess, OnError onError) async {
    final api = context.hostURL! + Constant.featurePath + context.apiKey!;
    await client.consumeGetRequest(
      api,
      (response) => onSuccess(
        FeaturedDataModel.fromJson(response),
      ),
      onError,
    );
  }
}

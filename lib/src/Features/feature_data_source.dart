import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

abstract class FeaturesFlowDelegate {
  void featuresFetchedSuccessfully(GBFeatures gbFeatures);
}

class FeatureDataSource {
  FeatureDataSource({required this.context, required this.client});
  final GBContext context;
  final BaseClient client;

  Future<FeaturedDataModel> fetchFeatures() async {
    final api = context.hostURL! + Constant.featurePath + context.apiKey!;
    final data = await client.consumeGetRequest(api);
    return FeaturedDataModel.fromJson(data);
  }
}

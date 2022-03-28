import '../Features/features_model.dart';
import '../Network/network.dart';
import '../Utils/constant.dart';
import '../model/context.dart';

abstract class FeaturesFlowDelegate {
  void featuresFetchedSuccessfully(GBFeatures gbFeatures);
}

class FeatureDataSource {
  FeatureDataSource({
    required this.context,
    required this.client,
  });
  final GBContext context;
  final BaseClient client;

  Future<FeaturedDataModel> fetchFeatures() async {
    final api = context.hostURL! + Constant.featurePath + context.apiKey!;
    await client.consumeGetRequest(api, onSuccess);
    setUpModel();
    return model;
  }

  late FeaturedDataModel model;
  late Map<String, dynamic> data;

  /// Assign response to local variable [data]
  void onSuccess(response) {
    data = response;
  }

  /// Initialize [model] from the [data]
  void setUpModel() {
    model = FeaturedDataModel.fromMap(data);
  }
}

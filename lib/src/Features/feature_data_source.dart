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
    final response = await client.get(api);
    return FeaturedDataModel.fromMap(response.data);
  }
}

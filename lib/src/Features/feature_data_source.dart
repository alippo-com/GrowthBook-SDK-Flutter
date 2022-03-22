import 'package:r_sdk_m/src/Features/features_model.dart';
import 'package:r_sdk_m/src/Network/network.dart';

class FeatureDataSource {
  FeatureDataSource(BaseClient client) : _baseClient = client;

  final BaseClient _baseClient;

  Future<FeaturedDataModel?> fetchFeatures() async {
    final response = await _baseClient
        .get('https://cdn.growthbook.io/api/features/key_dev_48ecac96a7facd6c');
    if (response.statusCode == 200) {
      return FeaturedDataModel.fromMap(response.data);
    }
    return null;
  }
}

import 'package:r_sdk_m/src/Features/feature_data_source.dart';
import 'package:r_sdk_m/src/Utils/utils.dart';

class FeatureViewModel {
  const FeatureViewModel({
    required this.delegate,
    required this.source,
  });
  final FeaturesFlowDelegate delegate;

  final FeatureDataSource source;

  Future<void> fetchFeature() async {
    try {
      final model = await source.fetchFeatures();
      delegate.featuresFetchedSuccessfully(model.feature);
      customLogger('FeatureVieModel have fetched features successfully.');
    } catch (e) {
      customLogger('FeatureViewModel Failed to fetch features');
      rethrow;
    }
  }
}

import 'package:growthbook_sdk_flutter/src/Features/feature_data_source.dart';
import 'package:growthbook_sdk_flutter/src/Utils/utils.dart';

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
      rethrow;
    }
  }
}

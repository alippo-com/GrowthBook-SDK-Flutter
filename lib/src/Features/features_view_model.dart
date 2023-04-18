import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

class FeatureViewModel {
  const FeatureViewModel({
    required this.delegate,
    required this.source,
  });
  final FeaturesFlowDelegate delegate;

  final FeatureDataSource source;

  Future<void> fetchFeature() async {
    try {
      FeaturedDataModel? model = await source.fetchFeatures();
      if (model == null) {
        customLogger('FeatureVieModel did NOT fetched features successfully.');
        return;
      }
      delegate.featuresFetchedSuccessfully(model.features);
      customLogger('FeatureVieModel have fetched features successfully.');
    } catch (e) {
      rethrow;
    }
  }
}

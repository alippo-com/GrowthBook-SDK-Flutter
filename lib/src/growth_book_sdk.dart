import 'dart:async';

import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

typedef VoidCallback = void Function();

class GBSDKBuilderApp {
  GBSDKBuilderApp({
    required this.hostURL,
    required this.apiKey,
    required this.growthBookTrackingCallBack,
    this.attributes = const <String, dynamic>{},
    this.qaMode = false,
    this.enable = true,
    this.forcedVariations = const <String, int>{},
    this.client,
    this.features = const <String, GBFeature>{},
  });

  final String apiKey;
  final String hostURL;
  final bool enable;
  final bool qaMode;
  final Map<String, dynamic>? attributes;
  final Map<String, int> forcedVariations;
  final TrackingCallBack growthBookTrackingCallBack;
  final BaseClient? client;
  final Map<String, GBFeature> features;

  Future<GrowthBookSDK> initialize() async {
    final gbContext = GBContext(
      apiKey: apiKey,
      hostURL: hostURL,
      enabled: enable,
      qaMode: qaMode,
      attributes: attributes,
      forcedVariation: forcedVariations,
      trackingCallBack: growthBookTrackingCallBack,
      features: features,
    );
    final gb = GrowthBookSDK._(
      context: gbContext,
      client: client,
    );
    await gb.refresh();
    return gb;
  }
}

/// The main export of the libraries is a simple GrowthBook wrapper class that
/// takes a Context object in the constructor.
/// It exposes two main methods: feature and run.
class GrowthBookSDK extends FeaturesFlowDelegate {
  GrowthBookSDK._(
      {required GBContext context, GBFeatures? features, BaseClient? client})
      : _context = context,
        _baseClient = client ?? DioClient() {
    if (features != null) {
      _context.features = features;
    }
  }

  final GBContext _context;

  final BaseClient _baseClient;

  /// The complete data regarding features & attributes etc.
  GBContext get context => _context;

  /// Retrieved features.
  GBFeatures get features => _context.features;

  @override
  void featuresFetchedSuccessfully(GBFeatures gbFeatures) {
    _context.features = gbFeatures;
  }

  Future<void> refresh() async {
    final featureViewModel = FeatureViewModel(
      delegate: this,
      source: FeatureDataSource(
        client: _baseClient,
        context: _context,
        onError: (e, s) {
          throw Exception(e);
        },
      ),
    );
    await featureViewModel.fetchFeature();
  }

  GBFeatureResult feature(String id) {
    return GBFeatureEvaluator().evaluateFeature(_context, id);
  }

  GBExperimentResult run(GBExperiment experiment) {
    return GBExperimentEvaluator()
        .evaluateExperiment(context: context, experiment: experiment);
  }

  /// Replaces the Map of user attributes that are used to assign variations
  void setAttributes(Map<String, dynamic> attributes) {
    context.attributes = attributes;
  }
}

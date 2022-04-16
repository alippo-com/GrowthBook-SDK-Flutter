import 'package:flutter/cupertino.dart';
import 'package:growthbook_sdk_flutter/src/Evaluator/feature_evaluator.dart';
import 'package:growthbook_sdk_flutter/src/Features/features_view_model.dart';
import 'package:growthbook_sdk_flutter/src/Network/network.dart';
import 'package:growthbook_sdk_flutter/src/model/features.dart';

import 'Features/feature_data_source.dart';
import 'Utils/utils.dart';
import 'model/context.dart';

abstract class SDKBuilder {
  SDKBuilder({
    required this.apiKey,
    required this.hostURL,
    required this.attributes,
    required this.growthBookTrackingCallBack,
  })  : qaMode = false,
        forcedVariations = <String, int>{},
        enable = true;

  final String apiKey;
  final String hostURL;
  final Map<String, dynamic> attributes;
  final TrackingCallBack growthBookTrackingCallBack;

  bool qaMode;

  bool enable;

  Map<String, int> forcedVariations;

  ///  Set Forced Variations - Default Empty
  SDKBuilder setForcedVariations(Map<String, int> forcedVariations) {
    this.forcedVariations = forcedVariations;
    return this;
  }

  /// Set Enabled - Default Disabled - If Enabled - then experiments will be disabled
  SDKBuilder setQAMode(bool value) {
    qaMode = value;
    return this;
  }

  GrowthBookSDK initialize();
}

class GBSDKBuilderApp extends SDKBuilder {
  GBSDKBuilderApp({
    required String apiKey,
    required String hostURL,
    required Map<String, dynamic> attributes,
    required TrackingCallBack growthBookTrackingCallBack,
  }) : super(
            apiKey: apiKey,
            hostURL: hostURL,
            attributes: attributes,
            growthBookTrackingCallBack: growthBookTrackingCallBack) {
    customLogger('GrowthBook initialized successfully.');
  }

  BaseClient? _client;

  @override
  GrowthBookSDK initialize() {
    final gbContext = GBContext(
      apiKey: apiKey,
      hostURL: hostURL,
      enabled: enable,
      attributes: attributes,
      qaMode: qaMode,
      forcedVariation: forcedVariations,
      trackingCallBack: growthBookTrackingCallBack,
    );
    return GrowthBookSDK(context: gbContext, client: _client);
  }

  ///   Set Network Client - Network Client for Making API Calls
  SDKBuilder setNetworkDispatcher(BaseClient client) {
    _client = client;
    return this;
  }
}

// The main export of the libraries is a simple GrowthBook wrapper class that
// takes a Context object in the constructor.
// It exposes two main methods: feature and run.
class GrowthBookSDK extends FeaturesFlowDelegate {
  GrowthBookSDK(
      {required GBContext context,
      GBFeatures? features,
      BaseClient? client,
      VoidCallback? afterFetch})
      : _context = context,
        _baseClient = client ?? DioClient() {
    if (features != null) {
      _context.features = features;
    }
    refresh();
  }

  VoidCallback? afterFetch;

  ///
  final GBContext _context;

  GBContext get context => _context;

  GBFeatures get features => _context.features;

  final BaseClient _baseClient;

  @override
  void featuresFetchedSuccessfully(GBFeatures gbFeatures) {
    _context.features = gbFeatures;
  }

  Future<void> refresh() async {
    final featureViewModel = FeatureViewModel(
      delegate: this,
      source: FeatureDataSource(
          client: _baseClient, context: _context, onError: (e, s) {}),
    );
    await featureViewModel.fetchFeature().then((value) {
      if (afterFetch != null) {
        afterFetch!.call();
      }
    });
  }

  GBFeatureResult feature(String id) {
    return GBFeatureEvaluator().evaluateFeature(_context, id);
  }
}

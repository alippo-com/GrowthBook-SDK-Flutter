import 'package:r_sdk_m/src/Utils/constant.dart';
import 'package:r_sdk_m/src/model/context.dart';

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
            growthBookTrackingCallBack: growthBookTrackingCallBack);

  @override
  GrowthBookSDK initialize() {
    final gbContext = GBContext(
        apiKey: apiKey,
        hostURL: hostURL,
        enabled: enable,
        attributes: attributes,
        qaMode: qaMode,
        forcedVariation: forcedVariations,
        trackingCallBack: growthBookTrackingCallBack);
    return GrowthBookSDK(
      context: gbContext,
    );
  }
}

// The main export of the libraries is a simple GrowthBook wrapper class that takes a Context object in the constructor.
// It exposes two main methods: feature and run.

class GrowthBookSDK {
  GrowthBookSDK({required GBContext context, GBFeatures? features})
      : _context = context {
    if (features != null) {
      _context.features = features;
    }
  }

  ///
  final GBContext _context;
  GBContext get context => _context;
}

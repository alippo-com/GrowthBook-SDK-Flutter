import 'package:growthbook_sdk_flutter/src/model/features.dart';
import 'package:growthbook_sdk_flutter/src/utils/utils.dart';

class FeaturedDataModel {
  FeaturedDataModel({required this.feature});
  final GBFeatures feature;

  factory FeaturedDataModel.fromMap(Map<String, dynamic> data) {
    return FeaturedDataModel(
      feature: (data['features'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(
          key,
          GBFeature.fromMap(value),
        );
      }),
    );
  }
}

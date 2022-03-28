import 'package:r_sdk_m/src/Utils/constant.dart';
import 'package:r_sdk_m/src/model/features.dart';

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

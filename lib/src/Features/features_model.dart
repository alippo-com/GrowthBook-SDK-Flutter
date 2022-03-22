import 'package:r_sdk_m/src/model/features.dart';

class FeaturedDataModel {
  FeaturedDataModel({required this.feature});
  final GBFeature feature;

  factory FeaturedDataModel.fromMap(Map<String, dynamic> data) =>
      FeaturedDataModel(
        feature: data['features'],
      );
}

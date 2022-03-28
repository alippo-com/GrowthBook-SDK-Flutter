import 'package:r_sdk_m/src/Features/feature_data_source.dart';
import 'package:r_sdk_m/src/Utils/constant.dart';

class DataSourceMock extends FeaturesFlowDelegate {
  /// For data response.
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  /// For mocking error.
  bool _isError = false;
  bool get isError => _isError;

  @override
  void featuresFetchedSuccessfully(GBFeatures gbFeatures) {
    _isSuccess = true;
    _isError = false;
  }
}

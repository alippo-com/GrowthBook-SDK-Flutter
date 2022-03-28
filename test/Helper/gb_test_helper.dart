import 'dart:convert';

import '../test_cases/test_case.dart';

/// Test helper class.
class GBTestHelper {
  static final testData = jsonDecode(gbTestCases);

  static List<dynamic> getEvalConditionData() {
    return testData['evalCondition'];
  }

  static List<dynamic> getRunExperimentData() {
    return testData['run'];
  }

  static List<dynamic> getFNVHashData() {
    return testData['hash'];
  }

  static List<dynamic> getFeatureData() {
    return testData['feature'];
  }

  static List<dynamic> getBucketRangeData() {
    return testData['getBucketRange'];
  }

  static List<dynamic> getInNameSpaceData() {
    return testData['inNamespace'];
  }

  static List<dynamic> getChooseVariationData() {
    return testData['chooseVariation'];
  }

  static List<dynamic> getEqualWeightsData() {
    return testData['getEqualWeights'];
  }
}

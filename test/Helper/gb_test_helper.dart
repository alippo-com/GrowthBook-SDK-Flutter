import 'dart:convert';

import '../test_cases/test_case.dart';

/// Test helper class.
class GBTestHelper {
  static final testData = jsonDecode(gbTestCases);

  static List getEvalConditionData() {
    return testData['evalCondition'];
  }

  static List getRunExperimentData() {
    return testData['run'];
  }

  static List getFNVHashData() {
    return testData['hash'];
  }

  static List getFeatureData() {
    return testData['feature'];
  }

  static List getBucketRangeData() {
    return testData['getBucketRange'];
  }

  static List getInNameSpaceData() {
    return testData['inNamespace'];
  }

  static List getChooseVariationData() {
    return testData['chooseVariation'];
  }

  static List getEqualWeightsData() {
    return testData['getEqualWeights'];
  }
}

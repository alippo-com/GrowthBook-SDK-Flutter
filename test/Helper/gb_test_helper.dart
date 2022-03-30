import 'dart:convert';

import 'package:r_sdk_m/src/Utils/utils.dart';
import 'package:r_sdk_m/src/model/experiment.dart';
import 'package:r_sdk_m/src/model/features.dart';

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

class GBFeaturesTest {
  GBFeaturesTest({this.features, this.attributes});
  final GBFeatures? features;
  final dynamic attributes;

  factory GBFeaturesTest.fromMap(Map<String, dynamic> map) {
    return GBFeaturesTest(
        attributes: map['attributes'],
        features:
            (map['features'] as Map<String, dynamic>? ?? {}).map((key, value) {
          return MapEntry(
            key,
            GBFeature.fromMap(value),
          );
        }));
  }
}

class GBFeatureResultTest {
  GBFeatureResultTest({
    this.value,
    this.on = false,
    this.off = true,
    this.source,
    this.experiment,
    this.experimentResult,
  });
  dynamic value;
  bool? on;
  bool? off;
  String? source;
  GBExperimentResultTest? experimentResult;
  GBExperiment? experiment;
  factory GBFeatureResultTest.fromMap(Map<String, dynamic> map) =>
      GBFeatureResultTest(
        value: map['value'],
        on: map['on'],
        off: map['off'],
        source: map['source'],
        experiment: map['experiment'] != null
            ? GBExperiment.fromMap(map['experiment'])
            : null,
        experimentResult: map['experimentResult'] != null
            ? GBExperimentResultTest.fromMap(
                map['experimentResult'],
              )
            : null,
      );
}

class GBExperimentResultTest {
  GBExperimentResultTest({
    this.inExperiment = false,
    this.variationId,
    this.value,
    this.hashAttribute,
    this.hashValue,
  });

  /// Whether or not the user is part of the experiment
  bool? inExperiment;

  /// The array index of the assigned variation
  int? variationId;

  /// The array value of the assigned variation
  dynamic value;

  /// The user attribute used to assign a variation
  String? hashAttribute;

  ///  The value of that attribute
  String? hashValue;

  factory GBExperimentResultTest.fromMap(Map<String, dynamic> map) =>
      GBExperimentResultTest(
        value: map['value'],
        inExperiment: map['inExperiment'],
        variationId: map['variationId'],
        hashAttribute: map['hashAttribute'],
        hashValue: map['hashValue'],
      );
}

import '../Utils/constant.dart';

/// Defines a single experiment

class GBExperiment {
  GBExperiment({
    this.key,
    this.variations,
    this.hashAttribute,
    this.weights,
    this.active,
    this.coverage,
    this.force,
  });

  /// The globally unique tracking key for the experiment
  String? key;

  /// The different variations to choose between
  List? variations = [];

  /// A tuple that contains the namespace identifier, plus a range of coverage for the experiment
  /// All users included in the experiment will be forced into the specific variation index
  String? hashAttribute;

  /// How to weight traffic between variations. Must add to 1.
  List? weights;

  /// If set to false, always return the control (first variation)
  bool? active = true;

  /// What percent of users should be included in the experiment (between 0 and 1, inclusive)
  double? coverage;

  /// Optional targeting condition
  GBCondition? condition;

  /// All users included in the experiment will be forced into the specific variation index
  int? force;
}

/// The result of running an Experiment given a specific Context
class GBExperimentResult {
  GBExperimentResult({
    this.inExperiment,
    this.variationID,
    this.value,
    this.hasAttributes,
    this.hashValue,
  });

  /// Whether or not the user is part of the experiment
  bool? inExperiment;

  /// The array index of the assigned variation
  int? variationID;

  /// The array value of the assigned variation
  dynamic value;

  /// The user attribute used to assign a variation
  String? hasAttributes;

  /// The value of that attribute
  String? hashValue;
}

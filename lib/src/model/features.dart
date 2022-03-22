import '../Utils/constant.dart';
import 'experiment.dart';

/// A Feature object consists of possible values plus rules for how to assign values to users.
class GBFeature {
  /// The default value (should use null if not specified)
  ///2 Array of Rule objects that determine when and how the defaultValue gets overridden
  List<GBFeatureRule>? rules;
}

/// Rule object consists of various definitions to apply to calculate feature value
class GBFeatureRule {
  /// Optional targeting condition
  GBCondition? condition;

  /// What percent of users should be included in the experiment (between 0 and 1, inclusive)
  double? coverage;

  /// Immediately force a specific value (ignore every other option besides condition and coverage)
  Map<String, Object>? force;

  /// Run an experiment (A/B test) and randomly choose between these variations
  List<Map<String, dynamic>>? variations;

  /// The globally unique tracking key for the experiment (default to the feature key)
  String? key;

  /// How to weight traffic between variations. Must add to 1.
  List<double>? weights;

  /// A tuple that contains the namespace identifier, plus a range of coverage for the experiment.
  Map<double, double>? nameSpace;

  /// What user attribute should be used to assign variations (defaults to id)
  String? hashAttribute;
}

/// Enum For defining feature value source.
enum GBFeatureSource {
  /// Queried Feature doesn't exist in GrowthBook.
  unknownFeature,

  /// Default Value for the Feature is being processed.
  defaultValue,

  /// Forced Value for the Feature is being processed.
  force,

  /// Experiment Value for the Feature is being processed.
  experiment
}

/// Result for Feature
class GBFeatureResult {
  /// The assigned value of the feature
  dynamic value;

  /// The assigned value cast to a boolean
  bool? on = false;

  /// The assigned value cast to a boolean and then negated
  bool? off = true;

  /// One of "unknownFeature", "defaultValue", "force", or "experiment"

  GBFeatureSource? source;

  /// When source is "experiment", this will be the Experiment object used
  GBExperiment? experiment;

  ///When source is "experiment", this will be an ExperimentResult object

}

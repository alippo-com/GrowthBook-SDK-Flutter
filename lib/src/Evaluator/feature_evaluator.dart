import 'package:r_sdk_m/src/Evaluator/condition_evaluator.dart';
import 'package:r_sdk_m/src/Evaluator/experiment_evaluator.dart';
import 'package:r_sdk_m/src/model/context.dart';
import 'package:r_sdk_m/src/model/features.dart';

import '../Utils/gb_utils.dart';
import '../model/experiment.dart';

/// Feature Evaluator Class
/// Takes Context and Feature Key
/// Returns Calculated Feature Result against that key

class GBFeatureEvaluator {
  GBFeatureResult evaluateFeature(GBContext context, String key) {
    try {
      final targetFeature = context.features[key];
      if (targetFeature == null) {
        return _prepareResult(
          value: null,
          source: GBFeatureSource.unknownFeature,
        );
      }

      // Loop through the feature rules (if any)
      final rules = targetFeature.rules;

      // Return if rules is not provided.
      if (rules != null && rules.isNotEmpty) {
        for (var rule in rules) {
          /// If the rule has a condition and it evaluates to false,
          /// skip this rule and continue to the next one.

          if (rule.condition != null) {
            final attr = context.attributes;
            if (GBConditionEvaluator().evaluateCondition(
              attr!,
              rule.condition!,
            )) {
              continue;
            }
          }

          /// If rule.force is set
          if (rule.force != null) {
            /// If rule.coverage is set
            if (rule.coverage != null) {
              // final Key = rule.hashAttribute ?? Constant.idAttribute;

              final attributeValue = context.attributes?[key];

              if (attributeValue == null) {
                continue;
              } else {
                // Compute a hash using the Fowler–Noll–Vo algorithm (specifically fnv32-1a)
                final hashFNV = GBUtils().hash(attributeValue.toString() + key);
                // If the hash is greater than rule.coverage, skip the rule
                if (rule.coverage != null) {
                  if (hashFNV != null && hashFNV > rule.coverage!) {
                    continue;
                  }
                }
              }
            }
            return _prepareResult(
              value: rule.force,
              source: GBFeatureSource.force,
            );
          }

          /// If rule.force is not set.
          else {
            final exp = GBExperiment(
              key: rule.key ?? key,
              variations: rule.variations ?? [],
              coverage: rule.coverage,
              //// TODO : Check this.
              namespace: rule.nameSpace,
              weights: rule.weights,
              hashAttribute: rule.hashAttribute,
            );

            final result = GBExperimentEvaluator()
                .evaluateExperiment(context: context, experiment: exp);
            if (result.inExperiment ?? false) {
              return _prepareResult(
                value: result.value,
                source: GBFeatureSource.experiment,
                experiment: exp,
                experimentResult: result,
              );
            } else {
              // If result.inExperiment is false, skip this rule and continue to the next one.
              continue;
            }
          }
        }
      }
      // Return (value = defaultValue or null, source = defaultValue)
      return _prepareResult(
          value: targetFeature.defaultValue,
          source: GBFeatureSource.defaultValue);
    } catch (e) {
      // If the key doesn't exist in context.features, return immediately
      //(value = null, source = unknownFeature).
      return _prepareResult(
        value: null,
        source: GBFeatureSource.unknownFeature,
      );
    }
  }

  /// This is a helper method to create a FeatureResult object.
  /// Besides the passed-in arguments, there are two derived values - on and off, which are just the value cast to booleans.
  GBFeatureResult _prepareResult(
      {required dynamic value,
      required GBFeatureSource source,
      GBExperiment? experiment,
      GBExperimentResult? experimentResult}) {
    final isFalsy = value == null ||
        value.toString() == "false" ||
        value.toString() == '' ||
        value.toString() == "0";

    return GBFeatureResult(
        value: value,
        on: !isFalsy,
        off: isFalsy,
        source: source,
        experiment: experiment,
        experimentResult: experimentResult);
  }
}
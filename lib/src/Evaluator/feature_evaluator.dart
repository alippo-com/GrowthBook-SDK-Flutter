import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:r_sdk_m/src/model/context.dart';
import 'package:r_sdk_m/src/model/features.dart';

import '../model/experiment.dart';

/// Feature Evaluator Class
/// Takes Context and Feature Key
/// Returns Calculated Feature Result against that key

class GBFeatureEvaluator {
  GBFeatureResult? evaluateFeature(GBContext context, String key) {
    try {
      final targetFeature = context.features[key];

      // Loop through the feature rules (if any)
      final rules = targetFeature?.rules;

      // Return if rules is not provided.
      if (rules != null && rules.isNotEmpty) {
        for (var rule in rules) {
          /// If the rule has a condition and it evaluates to false,
          /// skip this rule and continue to the next one.

          if (rule.condition != null) {
            /// TODO
            /// Evaluate condition.
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
                // val hashFNV = GBUtils.hash(attributeValue + featureKey)
                // If the hash is greater than rule.coverage, skip the rule
                // if (hashFNV != null && hashFNV > rule.coverage) {
                //    }
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
              weights: rule.weights,
              hashAttribute: rule.hashAttribute,

              /// TODO
              /// Name space is remaining.
            );

            /// TODO: evaluate experiment.

          }
        }
      }
    } catch (e) {
      if (kReleaseMode || kDebugMode) {
        log('error occurred while evaluating result ${e.toString()}');
      }
      rethrow;
    }
    return null;
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

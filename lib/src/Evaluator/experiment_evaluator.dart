import 'package:r_sdk_m/src/Utils/constant.dart';
import 'package:r_sdk_m/src/model/context.dart';
import 'package:r_sdk_m/src/model/experiment.dart';

import '../Utils/gb_utils.dart';
import 'condition_evaluator.dart';

/// Experiment Evaluator Class
/// Takes Context & Experiment & returns Experiment Result
class GBExperimentEvaluator {
  /// Takes Context & Experiment & returns Experiment Result

  GBExperimentResult evaluateExperiment({
    required GBContext context,
    required GBExperiment experiment,
  }) {
    /// If experiment.variations has fewer than 2 variations, return immediately (not in experiment, variationId 0)
    ///
    /// If context.enabled is false, return immediately (not in experiment, variationId 0)
    if (experiment.variations!.length < 2 || !context.enabled!) {
      return _getExperimentResult(experiment: experiment, gbContext: context);
    }

    /// If context.forcedVariations[experiment.trackingKey] is defined, return immediately (not in experiment, forced variation)
    final forcedVariation = context.forcedVariation?[experiment.key];
    if (forcedVariation != null) {
      return _getExperimentResult(
          experiment: experiment,
          variationIndex: forcedVariation,
          gbContext: context);
    }

    /// If experiment.action is set to false, return immediately (not in experiment, variationId 0)
    if ((experiment.deactivated)) {
      return _getExperimentResult(experiment: experiment, gbContext: context);
    }

    // Get the user hash attribute and value (context.attributes[experiment.hashAttribute || "id"]) and if empty, return immediately (not in experiment, variationId 0)
    final attributeValue =
        context.attributes?[experiment.hashAttribute ?? Constant.idAttribute];
    if (attributeValue == null) {
      return _getExperimentResult(experiment: experiment, gbContext: context);
    }

    /// TODO: name_space remaining.
    /// If experiment.namespace is set, check if hash value is included in the range and if not, return immediately (not in experiment, variationId 0)
    // if (experiment.namespace != null) {
    //   var namespace = GBUtils().getGBNameSpace(experiment.namespace);
    //   if (experiment.namespace != null &&
    //       !GBUtils().inNamespace(attributeValue, namespace)) {
    //     return _getExperimentResult(experiment: experiment, gbContext: context);
    //   }
    // }

    // If experiment.condition is set and the condition evaluates to false, return immediately (not in experiment, variationId 0)
    if (experiment.condition != null) {
      final attr = context.attributes;
      if (!GBConditionEvaluator()
          .evaluateCondition(attr ?? {}, experiment.condition!)) {
        return _getExperimentResult(experiment: experiment, gbContext: context);
      }
    }

    /// Default variation weights and coverage if not specified
    final weights = experiment.weights;
    if (weights == null) {
      // Default weights to an even split between all variations
      experiment.weights =
          GBUtils().getEqualWeights(experiment.variations?.length ?? 1);
    }

    final coverage = experiment.coverage ?? 1;
    experiment.coverage = coverage;

    // If experiment.force is set, return immediately (not in experiment, variationId experiment.force)
    final forceExp = experiment.force;
    if (forceExp != null) {
      return _getExperimentResult(
        experiment: experiment,
        variationIndex: forceExp,
        inExperiment: false,
        gbContext: context,
      );
    }

    // If context.qaMode is true, return immediately (not in experiment, variationId 0)
    if (context.qaMode != null) {
      if (context.qaMode!) {
        return _getExperimentResult(experiment: experiment, gbContext: context);
      }
    }

    final result = _getExperimentResult(
      experiment: experiment,
      inExperiment: true,
      gbContext: context,
    );
    context.trackingCallBack!(experiment, result);

    return result;
  }

  ///  This is a helper method to create an ExperimentResult object.
  GBExperimentResult _getExperimentResult(
      {required GBContext gbContext,
      required GBExperiment experiment,
      int variationIndex = 0,
      bool inExperiment = false}) {
    var targetVariationIndex = variationIndex;

    // Check whether variationIndex lies within bounds of variations size
    if (experiment.variations != null) {
      if (targetVariationIndex < 0 ||
          targetVariationIndex >= experiment.variations!.length) {
        // Set to 0
        targetVariationIndex = 0;
      }
    }

    dynamic targetValue = 0;

    // check whether variations are non empty - then only query array against index
    if (experiment.variations != null) {
      if (experiment.variations!.isNotEmpty) {
        targetValue = experiment.variations![targetVariationIndex];
      }
    }

    // Hash Attribute - used for Experiment Calculations
    final hashAttribute = experiment.hashAttribute ?? Constant.idAttribute;
    // Hash Value against hash attribute
    final hashValue = gbContext.attributes?[hashAttribute] ?? "";

    return GBExperimentResult(
      inExperiment: inExperiment,
      variationID: targetVariationIndex,
      value: targetValue,
      hasAttributes: hashAttribute,
      hashValue: hashValue as String,
    );
  }
}

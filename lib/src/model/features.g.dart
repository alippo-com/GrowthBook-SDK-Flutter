// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'features.dart';

// **************************************************************************
// EnhancedEnumGenerator
// **************************************************************************

extension GBFeatureSourceFromStringExtension on Iterable<GBFeatureSource> {
  GBFeatureSource? fromString(String val) {
    final override = {
      'unknownFeature': GBFeatureSource.unknownFeature,
      'defaultValue': GBFeatureSource.defaultValue,
      'force': GBFeatureSource.force,
      'experiment': GBFeatureSource.experiment,
    }[val];
// ignore: unnecessary_this
    return this.contains(override) ? override : null;
  }
}

extension GBFeatureSourceEnhancedEnum on GBFeatureSource {
  @override
// ignore: override_on_non_overriding_member
  String get name => {
        GBFeatureSource.unknownFeature: 'unknownFeature',
        GBFeatureSource.defaultValue: 'defaultValue',
        GBFeatureSource.force: 'force',
        GBFeatureSource.experiment: 'experiment',
      }[this]!;
  bool get isUnknownFeature => this == GBFeatureSource.unknownFeature;
  bool get isDefaultValue => this == GBFeatureSource.defaultValue;
  bool get isForce => this == GBFeatureSource.force;
  bool get isExperiment => this == GBFeatureSource.experiment;
  T when<T>({
    required T Function() unknownFeature,
    required T Function() defaultValue,
    required T Function() force,
    required T Function() experiment,
  }) =>
      {
        GBFeatureSource.unknownFeature: unknownFeature,
        GBFeatureSource.defaultValue: defaultValue,
        GBFeatureSource.force: force,
        GBFeatureSource.experiment: experiment,
      }[this]!();
  T maybeWhen<T>({
    T? Function()? unknownFeature,
    T? Function()? defaultValue,
    T? Function()? force,
    T? Function()? experiment,
    required T Function() orElse,
  }) =>
      {
        GBFeatureSource.unknownFeature: unknownFeature,
        GBFeatureSource.defaultValue: defaultValue,
        GBFeatureSource.force: force,
        GBFeatureSource.experiment: experiment,
      }[this]
          ?.call() ??
      orElse();
}

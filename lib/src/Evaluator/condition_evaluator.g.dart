// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
part of 'condition_evaluator.dart';

// **************************************************************************
// EnhancedEnumGenerator
// **************************************************************************

extension GBAttributeTypeFromStringExtension on Iterable<GBAttributeType> {
  GBAttributeType? fromString(String val) {
    final override = {
      'string': GBAttributeType.gbString,
      'number': GBAttributeType.gbNumber,
      'boolean': GBAttributeType.gbBoolean,
      'array': GBAttributeType.gbArray,
      'object': GBAttributeType.gbObject,
      'null': GBAttributeType.gbNull,
      'unknown': GBAttributeType.gbUnknown,
    }[val];
    return contains(override) ? override : null;
  }
}

extension GBAttributeTypeEnhancedEnum on GBAttributeType {
  @override
// ignore: override_on_non_overriding_member
  String get name => {
        GBAttributeType.gbString: 'string',
        GBAttributeType.gbNumber: 'number',
        GBAttributeType.gbBoolean: 'boolean',
        GBAttributeType.gbArray: 'array',
        GBAttributeType.gbObject: 'object',
        GBAttributeType.gbNull: 'null',
        GBAttributeType.gbUnknown: 'unknown',
      }[this]!;
  bool get isGbString => this == GBAttributeType.gbString;
  bool get isGbNumber => this == GBAttributeType.gbNumber;
  bool get isGbBoolean => this == GBAttributeType.gbBoolean;
  bool get isGbArray => this == GBAttributeType.gbArray;
  bool get isGbObject => this == GBAttributeType.gbObject;
  bool get isGbNull => this == GBAttributeType.gbNull;
  bool get isGbUnknown => this == GBAttributeType.gbUnknown;
  T when<T>({
    required T Function() gbString,
    required T Function() gbNumber,
    required T Function() gbBoolean,
    required T Function() gbArray,
    required T Function() gbObject,
    required T Function() gbNull,
    required T Function() gbUnknown,
  }) =>
      {
        GBAttributeType.gbString: gbString,
        GBAttributeType.gbNumber: gbNumber,
        GBAttributeType.gbBoolean: gbBoolean,
        GBAttributeType.gbArray: gbArray,
        GBAttributeType.gbObject: gbObject,
        GBAttributeType.gbNull: gbNull,
        GBAttributeType.gbUnknown: gbUnknown,
      }[this]!();
  T maybeWhen<T>({
    T? Function()? gbString,
    T? Function()? gbNumber,
    T? Function()? gbBoolean,
    T? Function()? gbArray,
    T? Function()? gbObject,
    T? Function()? gbNull,
    T? Function()? gbUnknown,
    required T Function() orElse,
  }) =>
      {
        GBAttributeType.gbString: gbString,
        GBAttributeType.gbNumber: gbNumber,
        GBAttributeType.gbBoolean: gbBoolean,
        GBAttributeType.gbArray: gbArray,
        GBAttributeType.gbObject: gbObject,
        GBAttributeType.gbNull: gbNull,
        GBAttributeType.gbUnknown: gbUnknown,
      }[this]
          ?.call() ??
      orElse();
}

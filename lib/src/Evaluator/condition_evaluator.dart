///Both experiments and features can define targeting conditions using a syntax modeled after MongoDB queries.
///These conditions can have arbitrary nesting levels and evaluating them requires recursion.
///There are a handful of functions to define, and be aware that some of them may reference function definitions further below.

/// Enum For different Attribute Types supported by GrowthBook.
enum GBAttributeType {
  /// String Type Attribute.
  gbString,

  /// Number Type Attribute.
  gbNumber,

  /// Boolean Type Attribute.
  gbBoolean,

  //// Array Type Attribute.
  gbArray,

  /// Object Type Attribute.
  gbObject,

  /// Null Type Attribute.
  gbNull,

  /// Not Supported Type Attribute.
  gbUnknown
}

/// Evaluator class fro condition.

class GBConditionEvaluator {
  /// This is the main function used to evaluate a condition.
  /// - attributes : User Attributes
  /// - condition : to be evaluated

  bool? evaluateCondition() {
    return null;
  }
}

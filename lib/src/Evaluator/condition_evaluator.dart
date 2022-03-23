import '../Utils/utils.dart';

/// Both experiments and features can define targeting conditions using a syntax modeled after MongoDB queries.
/// These conditions can have arbitrary nesting levels and evaluating them requires recursion.
/// There are a handful of functions to define, and be aware that some of them may reference function definitions further below.

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

  bool evaluateCondition(
      Map<String, dynamic> attributes, GBCondition conditionOBJ) {
    if (!conditionOBJ.isValidJsonElement) {
      return false;
    } else {
      /// If conditionObj has a key $or, return evalOr(attributes, condition["$or"])
      var targetItems = conditionOBJ[r"$or"];
      if (targetItems != null) {
        return evalOr(attributes, targetItems);
      }

      /// If conditionObj has a key $nor, return !evalOr(attributes, condition["$nor"])
      targetItems = conditionOBJ[r"$nor"];
      if (targetItems != null) {
        return !evalOr(attributes, targetItems);
      }

      /// If conditionObj has a key $and, return !evalAnd(attributes, condition["$and"])
      targetItems = conditionOBJ[r"$and"];
      if (targetItems != null) {
        return evalAnd(attributes, targetItems);
      }

      // If conditionObj has a key $not, return !evalCondition(attributes, condition["$not"])
      var targetItem = conditionOBJ[r"$not"];
      if (targetItem != null) {
        return !evaluateCondition(attributes, targetItem);
      }
      // Loop through the conditionObj key/value pairs
      for (final key in conditionOBJ.keys) {
        final element = getPath(attributes, key);
        final value = conditionOBJ[key];
        if (value != null) {
          // If evalConditionValue(value, getPath(attributes, key)) is false, break out of loop and return false
          if (!evalConditionValue(value, element)) {
            return false;
          }
        }
      }
    }
    // Return true
    return true;
  }

  ///   Evaluate OR conditions against given attributes
  bool evalOr(
      Map<String, dynamic> attributes, Map<String, dynamic> conditionObj) {
    // If conditionObj is empty, return true
    if (conditionObj.isEmpty) {
      return true;
    } else {
      // Loop through the conditionObjects
      for (var i = 0; i < conditionObj.length; i++) {
        // If evalCondition(attributes, conditionObj[i]) is true, break out of the loop and return true
        if (evaluateCondition(attributes, conditionObj[i])) {
          return true;
        }
      }
    }
    // Return false
    return false;
  }

  /// Evaluate AND conditions against given attributes
  bool evalAnd(
      Map<String, dynamic> attributes, Map<String, dynamic> conditionObj) {
    // Loop through the conditionObjects

    for (var i = 0; i < conditionObj.length; i++) {
      // If evalCondition(attributes, conditionObj[i]) is false, break out of the loop and return false
      if (!evaluateCondition(attributes, conditionObj[i])) {
        return false;
      }
    }
    // Return true
    return true;
  }

  /// This accepts a parsed JSON object as input and returns true if every key in the object starts with $
  bool isOperatorObject(Map<String, dynamic> obj) {
    var isOperator = true;
    if (obj.keys.isNotEmpty) {
      for (var key in obj.keys) {
        if (!key.startsWith(r"$")) {
          isOperator = false;
          break;
        }
      }
    } else {
      isOperator = false;
    }
    return isOperator;
  }

  ///  This returns the data type of the passed in argument.
  GBAttributeType getType(Map<String, dynamic>? obj) {
    if (obj != null) {
      if (!obj.isValidJsonElement) {
        throw Exception('Not valid jsonElement');
      }
    }

    if (obj.isNull) {
      return GBAttributeType.gbNull;
    }
    final _value = obj![obj.values.first];

    /// Primitive type checks.
    if (_value.isString) {
      return GBAttributeType.gbString;
    }

    if (_value.isBoolean) {
      return GBAttributeType.gbBoolean;
    }

    if (_value.isNumber) {
      return GBAttributeType.gbNumber;
    }

    if (_value.isArray) {
      return GBAttributeType.gbArray;
    }

    if (_value.isMap) {
      return GBAttributeType.gbObject;
    }

    return GBAttributeType.gbUnknown;
  }

  /// Given attributes and a dot-separated path string, return the value at that path (or null/undefined if the path doesn't exist)
  Map<String, dynamic>? getPath(Map<String, dynamic>? obj, String key) {
    var paths = <String>[];

    if (key.contains(".")) {
      paths = key.split('.');
    } else {
      paths.add(key);
    }

    var element = obj;

    for (final path in paths) {
      if (element == null) {
        return null;
      }
      if (element.isValidJsonElement) {
        element = element[path];
      } else {
        return null;
      }
    }
    return element;
  }

  ///Evaluates Condition Value against given condition & attributes
  bool evalConditionValue(Map<String, dynamic>? conditionValue,
      Map<String, dynamic>? attributeValue) {
    // If conditionValue is a string, number, boolean, return true if it's "equal" to attributeValue and false if not.
    if (conditionValue?.values.first.isPrimitive &&
        attributeValue?.values.first.isPrimitive) {
      return conditionValue?.values.first == attributeValue?.values.first;
    }

    // If conditionValue is array, return true if it's "equal" - "equal" should do a deep comparison for arrays.
    if (conditionValue.isJsonArray) {
      if (attributeValue.isJsonArray) {
        if (conditionValue!.length == attributeValue!.length) {
          return attributeValue.length == conditionValue.length;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }

    // If conditionValue is an object, loop over each key/value pair:
    if (conditionValue.isValidJsonElement) {
      if (isOperatorObject(conditionValue!)) {
        for (final key in conditionValue.keys) {
          // If evalOperatorCondition(key, attributeValue, value) is false, return false
          if (attributeValue != null) {
            if (!evalOperatorCondition(
                key, attributeValue, conditionValue[key]!!)) {
              return false;
            }
          }
        }
      } else if (attributeValue != null) {
        return conditionValue == attributeValue;
      } else {
        return false;
      }
    }

    /// Return true
    return true;
  }

  ///
  /// This function is just a case statement that handles all the possible operators
  /// There are basic comparison operators in the form attributeValue {op} conditionValue.
  ///

  evalOperatorCondition(String operator, Map<String, dynamic> attributeValue,
      Map<String, dynamic> conditionValue) {
    if (attributeValue.isValidJsonElement &&
        conditionValue.isValidJsonElement) {
      /// Evaluate TYPE operator - whether both are of same type
      if (operator == "\$type") {
        return getType(attributeValue).toString();
      }
    }
  }
}

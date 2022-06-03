import 'package:enhanced_enum/enhanced_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';

// part 'condition_evaluator.g.dart';

/// Both experiments and features can define targeting conditions using a syntax modeled after MongoDB queries.
/// These conditions can have arbitrary nesting levels and evaluating them requires recursion.
/// There are a handful of functions to define, and be aware that some of them may reference function definitions further below.
/// Enum For different Attribute Types supported by GrowthBook.
@EnhancedEnum()
enum GBAttributeType {
  /// String Type Attribute.
  @EnhancedEnumValue(name: 'string')
  gbString,

  /// Number Type Attribute.
  @EnhancedEnumValue(name: 'number')
  gbNumber,

  /// Boolean Type Attribute.
  @EnhancedEnumValue(name: 'boolean')
  gbBoolean,

  //// Array Type Attribute.
  @EnhancedEnumValue(name: 'array')
  gbArray,

  /// Object Type Attribute.
  @EnhancedEnumValue(name: 'object')
  gbObject,

  /// Null Type Attribute.
  @EnhancedEnumValue(name: 'null')
  gbNull,

  /// Not Supported Type Attribute.
  @EnhancedEnumValue(name: 'unknown')
  gbUnknown
}

/// Evaluator class fro condition.
class GBConditionEvaluator {
  /// This is the main function used to evaluate a condition.
  /// - attributes : User Attributes
  /// - condition : to be evaluated

  bool evaluateCondition(dynamic attributes, GBCondition conditionOBJ) {
    if (conditionOBJ.isArray) {
      return false;
    } else {
      /// If conditionObj has a key $or, return evalOr(attributes, condition["$or"])
      var targetItems = conditionOBJ["\$or"];
      if (targetItems != null) {
        return evalOr(attributes, targetItems);
      }

      /// If conditionObj has a key $nor, return !evalOr(attributes, condition["$nor"])
      targetItems = conditionOBJ["\$nor"];
      if (targetItems != null) {
        return !evalOr(attributes, targetItems);
      }

      /// If conditionObj has a key $and, return !evalAnd(attributes, condition["$and"])
      targetItems = conditionOBJ["\$and"];
      if (targetItems != null) {
        return evalAnd(attributes, targetItems);
      }

      // If conditionObj has a key $not, return !evalCondition(attributes, condition["$not"])
      var targetItem = conditionOBJ["\$not"];
      if (targetItem != null) {
        return !evaluateCondition(attributes, targetItem);
      }
      // Loop through the conditionObj key/value pairs
      for (final key in conditionOBJ.keys) {
        final element = getPath(attributes, key);
        final value = conditionOBJ[key];
        if (value != null) {
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
  bool evalOr(Map<String, dynamic> attributes, List conditionObj) {
    // If conditionObj is empty, return true
    if (conditionObj.isEmpty) {
      return true;
    } else {
      // Loop through the conditionObjects
      for (var item in conditionObj) {
        // If evalCondition(attributes, conditionObj[i]) is true, break out of
        // the loop and return true
        if (evaluateCondition(attributes, item)) {
          return true;
        }
      }
    }
    // Return false
    return false;
  }

  /// Evaluate AND conditions against given attributes
  bool evalAnd(dynamic attributes, List conditionObj) {
    // Loop through the conditionObjects

    // Loop through the conditionObjects
    for (var item in conditionObj) {
      // If evalCondition(attributes, conditionObj[i]) is true, break out of
      // the loop and return false
      if (!evaluateCondition(attributes, item)) {
        return false;
      }
    }
    // Return true
    return true;
  }

  /// This accepts a parsed JSON object as input and returns true if every key
  /// in the object starts with $
  bool isOperatorObject(dynamic obj) {
    var isOperator = true;
    if ((obj as Object?).isMap) {
      if ((obj as Map<String, dynamic>).keys.isNotEmpty) {
        for (var key in obj.keys) {
          if (!key.startsWith(r"$")) {
            isOperator = false;
            break;
          }
        }
      }
    } else {
      isOperator = false;
    }
    return isOperator;
  }

  ///  This returns the data type of the passed in argument.
  GBAttributeType getType(dynamic obj) {
    if (obj == null) {
      return GBAttributeType.gbNull;
    }

    final _value = obj as Object;

    if (_value.isPrimitive) {
      if (_value.isString) {
        return GBAttributeType.gbString;
      } else if (_value == true || _value == false) {
        return GBAttributeType.gbBoolean;
      } else {
        return GBAttributeType.gbNumber;
      }
    }

    if (_value.isArray) {
      return GBAttributeType.gbArray;
    }

    if (_value.isMap) {
      return GBAttributeType.gbObject;
    }

    return GBAttributeType.gbUnknown;
  }

  /// Given attributes and a dot-separated path string, return the value at
  /// that path (or null/undefined if the path doesn't exist)
  dynamic getPath(dynamic obj, String key) {
    var paths = <String>[];

    if (key.contains(".")) {
      paths = key.split('.');
    } else {
      paths.add(key);
    }

    dynamic element = obj;
    for (final path in paths) {
      if (element == null || (element as Object).isArray) {
        return null;
      }
      if ((element is Map)) {
        element = element[path];
      } else {
        return null;
      }
    }

    return element;
  }

  ///Evaluates Condition Value against given condition & attributes
  bool evalConditionValue(dynamic conditionValue, dynamic attributeValue) {
    // If conditionValue is a string, number, boolean, return true if it's
    // "equal" to attributeValue and false if not.
    if ((conditionValue as Object?).isPrimitive &&
        (attributeValue as Object?).isPrimitive) {
      return conditionValue == attributeValue;
    }

    // If conditionValue is array, return true if it's "equal" - "equal" should
    // do a deep comparison for arrays.
    if (conditionValue is List) {
      if (attributeValue is List) {
        if (conditionValue.length == attributeValue.length) {
          return listEquals(conditionValue, attributeValue);
        } else {
          return false;
        }
      } else {
        return false;
      }
    }

    // If conditionValue is an object, loop over each key/value pair:
    if (conditionValue is Map) {
      if (isOperatorObject(conditionValue)) {
        for (var key in conditionValue.keys) {
          // If evalOperatorCondition(key, attributeValue, value)
          // is false, return false
          if (!evalOperatorCondition(
              key, attributeValue, conditionValue[key])) {
            return false;
          }
        }
      } else if (attributeValue != null) {
        if (attributeValue is Map) {
          return mapEquals(conditionValue, attributeValue);
        } else {
          return attributeValue == conditionValue;
        }
      } else {
        return false;
      }
    }

    /// Return true
    return true;
  }

  /// This checks if attributeValue is an array, and if so at least one of the
  /// array items must match the condition
  bool elemMatch(dynamic attributeValue, dynamic condition) {
    // Loop through items in attributeValue
    if (attributeValue is List) {
      for (final item in attributeValue) {
        // If isOperatorObject(condition)
        if (isOperatorObject(condition)) {
          // If evalConditionValue(condition, item), break out of loop and
          //return true
          if (evalConditionValue(condition, item)) {
            return true;
          }
        }
        // Else if evalCondition(item, condition), break out of loop and
        //return true
        else if (evaluateCondition(item, condition)) {
          return true;
        }
      }
    }
    // If attributeValue is not an array, return false
    return false;
  }

  /// This function is just a case statement that handles all the possible operators
  /// There are basic comparison operators in the form attributeValue {op}
  ///  conditionValue.
  bool evalOperatorCondition(
      String operator, dynamic attributeValue, dynamic conditionValue) {
    /// Evaluate TYPE operator - whether both are of same type
    if (operator == "\$type") {
      return getType(attributeValue).name == conditionValue;
    }
    // Evaluate NOT operator - whether condition doesn't contain attribute
    if (operator == "\$not") {
      return !evalConditionValue(conditionValue, attributeValue);
    }
    // Evaluate EXISTS operator - whether condition contains attribute
    if (operator == "\$exists") {
      if (conditionValue.toString() == 'false' && attributeValue == null) {
        return true;
      } else if (conditionValue.toString() == 'true' &&
          attributeValue != null) {
        return true;
      }
    }

    /// There are three operators where conditionValue is an array
    if (conditionValue is List) {
      switch (operator) {
        case '\$in':
          return conditionValue.contains(attributeValue);

        /// Evaluate NIN operator - attributeValue not in the conditionValue
        /// array.
        case '\$nin':
          return !conditionValue.contains(attributeValue);

        /// Evaluate ALL operator - whether condition contains all attribute
        case '\$all':
          if (attributeValue is List) {
            /// Loop through conditionValue array
            /// If none of the elements in the attributeValue array pass
            /// evalConditionValue(conditionValue[i], attributeValue[j]),
            /// return false.
            // for (var x = 0; x < (conditionValue).length; x++) {

            for (var con in conditionValue) {
              var result = false;
              for (var attr in attributeValue) {
                if (evalConditionValue(con, attr)) {
                  result = true;
                }
              }
              if (!result) {
                return result;
              }
            }

            return true;
          } else {
            /// If attributeValue is not an array, return false
            return false;
          }
        default:
          return false;
      }
    } else if (attributeValue is List) {
      switch (operator) {

        /// Evaluate ELEMENT-MATCH operator - whether condition matches attribute
        case "\$elemMatch":
          return elemMatch(attributeValue, conditionValue);

        /// Evaluate SIE operator - whether condition size is same as that
        /// of attribute
        case "\$size":
          return evalConditionValue(
            conditionValue,
            (attributeValue).length,
          );

        default:
      }
    } else if ((attributeValue as Object?).isPrimitive &&
        (conditionValue as Object?).isPrimitive) {
      late final num target;
      late final num source;
      void setupVariable() {
        if (attributeValue is num && conditionValue is num) {
          target = conditionValue;
          source = attributeValue;
        } else if (attributeValue is String && conditionValue is String) {
          target = conditionValue.calculateWeight();
          source = attributeValue.calculateWeight();
        }
      }

      setupVariable();

      switch (operator) {

        /// Evaluate EQ operator - whether condition equals to attribute
        case '\$eq':
          return source == target;

        /// Evaluate NE operator - whether condition doesn't equal to attribute
        case '\$ne':
          return source != target;

        // Evaluate LT operator - whether attribute less than to condition
        case '\$lt':
          return source < target;

        /// Evaluate LTE operator - whether attribute less than or equal to condition
        case '\$lte':
          return source <= target;

        // Evaluate GT operator - whether attribute greater than to condition
        case '\$gt':
          return source > target;

        case '\$gte':
          return source >= target;

        case '\$regex':
          try {
            final regEx = RegExp(conditionValue.toString());
            return regEx.hasMatch(attributeValue.toString());
          } catch (e) {
            return false;
          }
      }
    }
    return false;
  }
}

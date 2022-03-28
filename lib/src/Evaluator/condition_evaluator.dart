import 'package:r_sdk_m/src/Utils/constant.dart';
import 'package:r_sdk_m/src/Utils/extension.dart';

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
        final element = getPath(attributes, key); //1
        final value = conditionOBJ[key]; //{"$ne : 1"}
        if (!evalConditionValue(value, element)) {
          return false;
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
  bool evalAnd(dynamic attributes, List conditionObj) {
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
        ((attributeValue) as Object?).isPrimitive) {
      return conditionValue == attributeValue;
    }

    // If conditionValue is array, return true if it's "equal" - "equal" should
    // do a deep comparison for arrays.
    if (conditionValue.isArray) {
      if ((attributeValue as Object).isArray) {
        if ((conditionValue as List).length ==
            (attributeValue as List).length) {
          return attributeValue.length == conditionValue.length;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }

    // If conditionValue is an object, loop over each key/value pair:
    if ((conditionValue as Object).isMap) {
      if (isOperatorObject(conditionValue as Map<String, dynamic>)) {
        for (final key in conditionValue.keys) {
          // If evalOperatorCondition(key, attributeValue, value)
          // is false, return false
          if (attributeValue != null) {
            if (!evalOperatorCondition(
                key, attributeValue, conditionValue[key])) {
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

  /// This checks if attributeValue is an array, and if so at least one of the
  /// array items must match the condition
  bool elemMatch(dynamic attributeValue, dynamic condition) {
    // Loop through items in attributeValue
    if ((attributeValue as Object).isArray) {
      for (final item in attributeValue as List) {
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
    if (operator == r"$type") {
      return getType(attributeValue).toString() == attributeValue?.toString();
    }
    // Evaluate NOT operator - whether condition doesn't contain attribute
    if (operator == r"$not") {
      return !evalConditionValue(conditionValue, attributeValue);
    }
    // Evaluate EXISTS operator - whether condition contains attribute
    if (operator == r"$exists") {
      var targetPrimitiveValue = conditionValue;
      if (targetPrimitiveValue.toString() == "false" &&
          attributeValue == null) {
        return true;
      } else if (targetPrimitiveValue == "true") {
        return true;
      }
    }

    /// There are three operators where conditionValue is an array

    if ((conditionValue as Object).isArray) {
      switch (operator) {
        case '\$in':
          return (conditionValue as List).contains(attributeValue);

        /// Evaluate NIN operator - attributeValue not in the conditionValue
        /// array.
        case '\$nin':
          return !(conditionValue as List).contains(attributeValue);

        /// Evaluate ALL operator - whether condition contains all attribute
        case '\$all':
          if ((attributeValue as Object).isArray) {
            /// Loop through conditionValue array
            /// If none of the elements in the attributeValue array pass
            /// evalConditionValue(conditionValue[i], attributeValue[j]),
            /// return false.
            for (var x = 0; x < (conditionValue as List).length; x++) {
              var result = false;
              if ((attributeValue as List).isNotEmpty) {
                for (var i = 0; i < attributeValue.length; i++) {
                  if (evalConditionValue(
                      conditionValue[x], attributeValue[i])) {
                    result = true;
                  }
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
    } else if ((attributeValue as Object).isArray) {
      switch (operator) {

        /// Evaluate ELEMENT-MATCH operator - whether condition matches attribute
        case "\$elemMatch":
          return elemMatch(attributeValue, conditionValue);

        /// Evaluate SIE operator - whether condition size is same as that
        /// of attribute
        case "\$size":
          return evalConditionValue(
            conditionValue,
            attributeValue,
          );

        default:
      }
    } else if ((attributeValue).isPrimitive && (conditionValue).isPrimitive) {
      var targetPrimitiveValue = conditionValue;
      var sourcePrimitiveValue = attributeValue;
      final parsedTarget = double.tryParse(targetPrimitiveValue.toString());
      final parsedSource = double.tryParse(sourcePrimitiveValue.toString());

      if (parsedTarget == null || parsedSource == null) {
        return false;
      }

      switch (operator) {

        /// Evaluate EQ operator - whether condition equals to attribute
        case '\$eq':
          return sourcePrimitiveValue == targetPrimitiveValue;

        /// Evaluate NE operator - whether condition doesn't equal to attribute
        case '\$ne':
          return sourcePrimitiveValue != targetPrimitiveValue;

        // Evaluate LT operator - whether attribute less than to condition
        case '\$lt':
          return double.parse(sourcePrimitiveValue.toString()) <
              double.parse(targetPrimitiveValue.toString());

        /// Evaluate LTE operator - whether attribute less than or equal to condition
        case '\$lte':
          return double.parse(sourcePrimitiveValue.toString()) <=
              double.parse(targetPrimitiveValue.toString());

        // Evaluate GT operator - whether attribute greater than to condition
        case '\$gt':
          return double.parse(sourcePrimitiveValue.toString()) >
              double.parse(targetPrimitiveValue.toString());

        case '\$gte':
          return double.parse(sourcePrimitiveValue.toString()) >=
              double.parse(targetPrimitiveValue.toString());
        case '\$regex':
          try {
            final regEx = RegExp(targetPrimitiveValue.toString());
            return regEx.hasMatch(sourcePrimitiveValue.toString());
          } catch (e) {
            return false;
          }
      }
    }
    return false;
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:r_sdk_m/src/Evaluator/condition_evaluator.dart';
import 'package:r_sdk_m/src/Utils/utils.dart';

import '../Helper/gb_test_helper.dart';

void main() {
  group('Condition test', () {
    List evaluateCondition;
    evaluateCondition = GBTestHelper.getEvalConditionData();

    test('Test conditions', () {
      final failedScenarios = <String>[];
      final passedScenarios = <String>[];
      for (final item in evaluateCondition) {
        if ((item as Object?).isArray) {
          final localItem = item as List;
          final evaluator = GBConditionEvaluator();
          final result =
              evaluator.evaluateCondition(localItem[2], localItem[1]);
          final status = localItem[0].toString() +
              "\nExpected Result - " +
              localItem[3].toString() +
              "\nActual result - " +
              result.toString() +
              "\n\n";
          if (localItem[3].toString() == result.toString()) {
            passedScenarios.add(status);
          } else {
            failedScenarios.add(status);
          }
        }
      }
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:r_sdk_m/src/Evaluator/feature_evaluator.dart';
import 'package:r_sdk_m/src/model/context.dart';

import '../Helper/gb_test_helper.dart';

void main() {
  group('Feature Evaluator', () {
    late final List evaluateCondition;
    setUpAll(() {
      evaluateCondition = GBTestHelper.getFeatureData();
    });
    test('Test Feature', () {
      final failedScenarios = <String>[];
      final passedScenarios = <String>[];

      for (final item in evaluateCondition) {
        final testData = GBFeaturesTest.fromMap(item[1]);
        final attributes = testData.attributes;
        final gbContext = GBContext(
            enabled: true,
            attributes: attributes,
            forcedVariation: {},
            qaMode: true,
            trackingCallBack: (_, __) {});
        if (testData.features != null) {
          gbContext.features = testData.features!;
        }

        final evaluator = GBFeatureEvaluator();
        final result = evaluator.evaluateFeature(gbContext, item[2]);
        final expectedResult = GBFeatureResultTest.fromMap(item[3]);

        final status = item[0].toString() +
            "\nValue expected- " +
            expectedResult.value.toString() +
            "\nValue actual- " +
            result.value.toString() +
            "\nOn  expected -" +
            expectedResult.on.toString() +
            "\nOn  actual -" +
            result.on.toString() +
            "\nOff  expected -" +
            expectedResult.off.toString() +
            "\nOff actual -" +
            result.off.toString() +
            "\nSource  expected -" +
            expectedResult.source.toString() +
            "\nSource  actual -" +
            "${result.source?.name.toString()}" +
            "\nExperiment  expected -" +
            "${expectedResult.experiment?.key.toString()}" +
            "\nExperiment  actual -" +
            "${result.experiment?.key}" +
            "\nExperimentResult expected -" +
            "${expectedResult.experimentResult?.variationId.toString()}" +
            "\nExperimentResult  actual -" +
            "${result.experimentResult?.variationID.toString()}" +
            "\n\n";
        if (result.value.toString() == expectedResult.value.toString() &&
            result.on.toString() == expectedResult.on.toString() &&
            result.off.toString() == expectedResult.off.toString() &&
            result.source?.name.toString() == expectedResult.source &&
            result.experiment?.key == expectedResult.experiment?.key &&
            result.experimentResult?.variationID ==
                expectedResult.experimentResult?.variationId) {
          passedScenarios.add(status);
        } else {
          failedScenarios.add(status);
          // print(status);
          // log(status);
//           print(
//               '''"${result.value.toString()}" == "${expectedResult.value.toString()}"
// "${result.on.toString()}" == "${expectedResult.on.toString()}"
// "${result.off.toString()}" == "${expectedResult.off.toString()}"
// "${result.source?.name.toString()}" == "${expectedResult.source}"
// "${result.experiment?.key}" == "${expectedResult.experiment?.key}"
// "${result.experimentResult?.variationID}" ==
// "${expectedResult.experimentResult?.variationId}"

// ''');
        }
      }
      // print(failedScenarios.length);
    });
  });
}

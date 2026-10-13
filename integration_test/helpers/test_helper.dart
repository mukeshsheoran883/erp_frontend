
import 'package:flutter_test/flutter_test.dart';

import 'result_model.dart';
import 'test_utils.dart';

class TestHelper {
  static void testModule({required String moduleName, required List<TestCase> testCases}) {
    ModuleResult result = ModuleResult(moduleName: moduleName, scenarios: []);

    /// Prepare the [ModuleResult] with all cases, scenarios and steps for the json object
    for (final i in testCases) {
      Scenario scenario = Scenario(
        scenarioName: i.caseDescription,
        passed: false,
        steps: [],
        testResponse: TestResponse(extraScreenshots: [], failedAtStep: '', failedScreenshot: '', successScreenshot: ''),
      );

      for (final step in i.operations) {
        scenario.steps.add(step.operationName);
      }
      result.scenarios.add(scenario);
    }
    // --------------------------------------------------------------------------------------------------

    /// Run the test cases
    group(moduleName, () {
      for (int i = 0; i < testCases.length; i++) {
        testCases[i].doTest(result.scenarios[i]);
      }
      test('save test result', () {
        TestUtils.results.add(result);
      });
    });
  }
}

class TestCase {
  String caseDescription;
  List<TestOperation> operations;

  TestCase({required this.caseDescription, required this.operations});

  void doTest(Scenario scenario) {
    testWidgets(caseDescription, (tester) async {
      bool passed = true;

      for (final i in operations) {
        try {
          await i.operation(tester, scenario);
        } catch (e) {
          scenario.passed = false;
          passed = false;
          String? path = await TestUtils.takeSnap(type: SnapType.none).operation(tester, scenario);
          scenario.testResponse.failedAtStep = i.operationName;
          if (scenario.testResponse.failedScreenshot.trim().isEmpty) {
            scenario.testResponse.failedScreenshot = path ?? '';
          } else if (path != null && path.trim().isNotEmpty) {
            scenario.testResponse.extraScreenshots.add(path.trim());
          }
          throw Exception(e);
        }
      }
      scenario.passed = passed;
      String? path = await TestUtils.takeSnap(type: SnapType.none).operation(tester, scenario);
      scenario.testResponse.failedAtStep = '';
      if (scenario.testResponse.successScreenshot.trim().isEmpty) {
        scenario.testResponse.successScreenshot = path ?? '';
      }
    });
  }
}

class TestOperation {
  String operationName;
  Function(WidgetTester, Scenario) operation;

  TestOperation({required this.operationName, required this.operation});
}

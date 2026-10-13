
class ModuleResult {
  String moduleName;
  List<Scenario> scenarios;

  ModuleResult({required this.moduleName, required this.scenarios});

  factory ModuleResult.fromJson(Map<String, dynamic> json) => ModuleResult(
        moduleName: json['module_name'] ?? '',
        scenarios:
            json['scenarios'] == null ? [] : List<Scenario>.from(json['scenarios'].map((x) => Scenario.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {'module_name': moduleName, 'scenarios': List<dynamic>.from(scenarios.map((x) => x.toJson()))};
}

class Scenario {
  String scenarioName;
  bool passed;
  List<String> steps;
  TestResponse testResponse;

  Scenario({
    required this.scenarioName,
    required this.passed,
    required this.steps,
    required this.testResponse,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) => Scenario(
        scenarioName: json['scenario_name'] ?? '',
        passed: json['passed'] ?? false,
        steps: json['steps'] == null ? [] : List<String>.from(json['steps'].map((x) => x)),
        testResponse: TestResponse.fromJson(json['test_response'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'scenario_name': scenarioName,
        'passed': passed,
        'steps': List<dynamic>.from(steps.map((x) => x)),
        'test_response': testResponse.toJson(),
      };
}

class TestResponse {
  List<String> extraScreenshots;
  String successScreenshot;
  String failedScreenshot;
  String failedAtStep;

  TestResponse({
    required this.extraScreenshots,
    required this.failedAtStep,
    required this.failedScreenshot,
    required this.successScreenshot,
  });

  factory TestResponse.fromJson(Map<String, dynamic> json) => TestResponse(
        extraScreenshots:
            json['extra_screenshots'] == null ? [] : List<String>.from(json['extra_screenshots'].map((x) => x)),
        failedAtStep: json['failed_at_step'] ?? '',
        failedScreenshot: json['success_screenshot'] ?? '',
        successScreenshot: json['failure_screenshot'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'extra_screenshots': List<dynamic>.from(extraScreenshots.map((x) => x)),
        'failed_at_step': failedAtStep,
        'success_screenshot': successScreenshot,
        'failure_screenshot': failedScreenshot,
      };
}

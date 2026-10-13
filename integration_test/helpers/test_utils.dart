
import 'dart:io';

import 'package:invently/assortment/services/navigation_service/app_route_model.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/main.dart';
import 'package:invently/provider/provider_register.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

import 'generate_html.dart';
import 'result_model.dart';
import 'test_helper.dart';

class TestUtils {
  static late ScreenshotController screenshotController;
  static late Directory resultDirectory;
  static late Directory resultDirectoryScreenshots;
  static late File htmlFile;
  static late DateTime testStartDateTime;
  static List<ModuleResult> results = [];

  static Future<void> initTestUtils() async {
    testStartDateTime = DateTime.now();
    screenshotController = ScreenshotController();
    final directory = Directory('./integration_test_results');
    if (directory.existsSync()) directory.deleteSync(recursive: true);
    directory.createSync(recursive: true);
    resultDirectory = directory;
    resultDirectoryScreenshots = Directory('${resultDirectory.uri.path}/screenshots/');
    resultDirectoryScreenshots.createSync(recursive: true);
    htmlFile = File('${resultDirectory.path}/results.html');
  }

  static void saveResults() {
    test('Saving HTML Test Result', () {
      generateAndSaveHtml(file: htmlFile, resultLis: results);
    });
  }

  static TestOperation initApp() => TestOperation(
        operationName: 'Initialize the app',
        operation: (tester, scenario) async {
          await tester.pumpWidget(
            Screenshot(
              controller: screenshotController,
              child: MultiProvider(providers: ProviderRegister.providers, child: const GemBiller()),
            ),
          );
          await tester.pumpAndSettle();
          await Future.delayed(const Duration(milliseconds: 200));
        },
      );

  static TestOperation widgetVisible({required Type widgetToFind, Matcher condition = findsOneWidget}) => TestOperation(
        operationName: 'Ensure widget -${widgetToFind.toString()}- is visible',
        operation: (tester, scenario) => expect(find.byType(widgetToFind), condition),
      );

  static TestOperation loaderVisible({Matcher condition = findsOneWidget}) => TestOperation(
        operationName: 'Ensure loader ${find.byType(CustomProgressIndicator)} is visible',
        operation: (tester, scenario) => expect(find.byType(CustomProgressIndicator), condition),
      );

  static TestOperation textVisible({required String text, Matcher condition = findsOneWidget}) => TestOperation(
        operationName: 'Ensure text -$text- is visible',
        operation: (tester, scenario) => expect(find.text(text), condition),
      );

  static TestOperation putText({
    required Type widget,
    required String text,
    required String inputText,
  }) =>
      TestOperation(
        operationName: 'Enter text -$inputText- to $text field',
        operation: (tester, scenario) async {
          await tester.pumpAndSettle();
          expect(find.widgetWithText(widget, text), findsAtLeast(1));
          await tester.enterText(find.widgetWithText(widget, text), inputText);
          await tester.pumpAndSettle();
        },
      );

  static TestOperation tapTextButton({required Type widget, required String text, bool loaderCheck = false}) =>
      TestOperation(
        operationName: 'Tap button with text -$text-',
        operation: (tester, scenario) async {
          await tester.pumpAndSettle();
          await tester.tap(find.widgetWithText(widget, text));
          await Future.delayed(const Duration(milliseconds: 10));
          if (loaderCheck) loaderVisible();
          await tester.pumpAndSettle();
        },
      );

  static TestOperation tapIconButton({required String icon, bool loaderCheck = false}) => TestOperation(
        operationName: 'Tap button with icon -${icon.split('/').last}-',
        operation: (tester, scenario) async {
          await tester.pumpAndSettle();
          await tester.tap(find.bySemanticsLabel(icon));
          await Future.delayed(const Duration(milliseconds: 10));
          if (loaderCheck) loaderVisible();
          await tester.pumpAndSettle();
        },
      );

  static TestOperation tapDropdown({required String hint, bool loaderCheck = false}) => TestOperation(
        operationName: 'Tap dropdown with hint -$hint-',
        operation: (tester, scenario) async {
          await tester.pumpAndSettle();
          await tester.tap(find.widgetWithText(CustomDropdown, hint));
          await tester.pumpAndSettle();
        },
      );

  static TestOperation dropdownOpened() => TestOperation(
        operationName: 'Ensure dropdown is opened',
        operation: (tester, scenario) => expect(find.byType(DropDownTile), findsAtLeast(1)),
      );

  static TestOperation tapDropdownItem({required String label}) => TestOperation(
        operationName: 'Tap dropdown item with label -$label-',
        operation: (tester, scenario) async {
          await tester.pumpAndSettle();
          await tester.tap(find.widgetWithText(DropDownTile, label));
          await Future.delayed(const Duration(milliseconds: 10));
          await tester.pumpAndSettle();
        },
      );

  static TestOperation scrollAndFind({required Finder list, required Finder item, double scrollTo = -100000}) =>
      TestOperation(
        operationName: 'Scrolling list to find given item',
        operation: (tester, scenario) async {
          await tester.pumpAndSettle();
          await Future.delayed(const Duration(seconds: 1));
          await tester.dragUntilVisible(item, list, Offset(0, scrollTo));
          await Future.delayed(const Duration(seconds: 1));
          await tester.pumpAndSettle();
        },
      );

  static TestOperation navigateTo({required AppRoute route}) => TestOperation(
        operationName: 'Navigate to ${route.name}',
        operation: (tester, scenario) => AppNavigator.navigate(route),
      );

  static TestOperation takeSnap({SnapType type = SnapType.extra}) => TestOperation(
        operationName: 'Take screenshot',
        operation: (tester, scenario) async {
          String filename = '${const Uuid().v1()}.png';
          String? path = await screenshotController.captureAndSave(resultDirectoryScreenshots.path, fileName: filename);

          if (type == SnapType.success) scenario.testResponse.successScreenshot = 'screenshots/$filename';
          if (type == SnapType.extra) scenario.testResponse.extraScreenshots.add('screenshots/$filename');
          if (type == SnapType.failure) scenario.testResponse.failedScreenshot = 'screenshots/$filename';
          return path == null ? null : 'screenshots/$filename';
        },
      );
}

enum SnapType {
  none,
  success,
  extra,
  failure;
}

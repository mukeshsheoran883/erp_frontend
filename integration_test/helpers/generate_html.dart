import 'dart:io';

import 'package:intl/intl.dart';

import 'result_model.dart';
import 'test_utils.dart';

void generateAndSaveHtml({required File file, required List<ModuleResult> resultLis}) {
  final htmlContent = _generateHtml(resultLis);
  file.writeAsStringSync(htmlContent);
}

String _redColor = '#fa0521';
String _greenColor = '#1cad17';
String _whiteColor = '#c4c4c4';
String _lightBlueColor = '#18c4de';
String _orangeColor = '#ffa530';
String _violetColor = '#b9d93b';

String _generateHtml(List<ModuleResult> resultList) {
  final dateTime = TestUtils.testStartDateTime;
  final Duration duration = DateTime.now().difference(dateTime);
  String formattedDate = '${DateFormat('dd-MM-yyyy HH:mm a').format(dateTime)} ${dateTime.timeZoneName}';

  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  String formattedDuration =
      '${hours.toString().padLeft(2, '0')} Hr: ${minutes.toString().padLeft(2, '0')} Min: ${seconds.toString().padLeft(2, '0')} Sec';

  final buffer = StringBuffer();

  int failed = 0;
  int passed = 0;
  for (final i in resultList) {
    for (final j in i.scenarios) {
      if (j.passed) {
        passed = passed + 1;
      } else {
        failed = failed + 1;
      }
    }
  }

  buffer.writeln('''
   <style>
        body {
            background-color: #1c1c1c;
        }
        </style>
  
<title>Flutter Test Results</title>
  <p><span style="font-size:32px;color:$_whiteColor"><strong>Test Results</strong> (</span><span style="color:$_greenColor;font-size:32;">$passed passed</span><span style="font-size:22px;color:$_whiteColor">, </span><span style="color:$_redColor;font-size:32px;">$failed Failed</span><span style="font-size:32px;color:$_whiteColor">)</span></p>
<p>&nbsp;</p>
  <h1 style = "color:$_whiteColor; font-size: 22;">
    Test Conducted On: $formattedDate<br>
    Test Duration: $formattedDuration 
  </h1>

  ''');

  for (final i in resultList) {
    bool failed = i.scenarios.map((e) => e.passed).contains(false);
    buffer.writeln('''
    <details>
        <summary  style="color: ${failed ? _orangeColor : _greenColor};
         font-size: 24px;
         font-weight: bold;
         cursor: pointer;
        ">${i.moduleName}</summary ><ul>${_getScenarioText(i.scenarios)}</ul>
    </details>
  ''');
  }

  return buffer.toString();
}

String _getScenarioText(List<Scenario> scenarios) {
  List<String> scenarioTest = [];
  for (final i in scenarios) {
    scenarioTest.add(_getSingleScenarioText(i));
  }

  return scenarioTest.join('');
}

String _getSingleScenarioText(Scenario scenario) {
  String failedAt = '';

  if (scenario.testResponse.failedAtStep.trim().isNotEmpty) {
    failedAt = '''
       <ul> <span  style="color: $_orangeColor;
         font-size: 18px;
         font-weight: bold;
        ">Failed at step: ${scenario.testResponse.failedAtStep.trim()}</span>
        </ul>
    ''';
  }

  return '''<details>
        <summary  style="color: ${scenario.passed ? _greenColor : _redColor};
         font-size: 20px;
         font-weight: bold;
         cursor: pointer;
        ">${scenario.scenarioName}</summary>
      
      $failedAt
      
   <ul> <details>
        <summary  style="color: $_lightBlueColor;
         font-size: 18px;
         font-weight: bold;
         cursor: pointer;
        ">Steps</summary >
        ${_getSteps(scenario.steps)}        
    </details> 
        </ul>
        
 
 ${_getImages(scenario)}
 
        
    </details>
  ''';
}

String _getSteps(List<String> steps) {
  List<String> stepsString = [];

  for (final i in steps) {
    stepsString.add('''
    <ul><span style="color:$_violetColor;font-size:18px;cursor: pointer;">$i</span></ul>
    ''');
  }
  return stepsString.join('\r\n');
}

String _getImages(Scenario scenario) {
  List<String> images = [];

  if (scenario.testResponse.failedScreenshot.trim().isNotEmpty) {
    images.add('''
       <ul> <details>
        <summary  style="color: $_whiteColor;
         font-size: 18px;
         font-weight: bold;
         cursor: pointer;
        ">Failed Image</summary >
         <img src= ${scenario.testResponse.failedScreenshot} alt="${scenario.testResponse.failedAtStep}" style="border: 5px solid $_redColor;
                   width: 150px; height: auto;
         ">
    </details> 
        </ul>
    ''');
  }
  if (scenario.testResponse.successScreenshot.trim().isNotEmpty) {
    images.add('''
       <ul> <details>
        <summary  style="color: $_whiteColor;
         font-size: 18px;
         font-weight: bold;
         cursor: pointer;
        ">Success Image</summary >
         <img src= ${scenario.testResponse.successScreenshot} alt="Success" style="border: 5px solid $_greenColor;
          width: 150px; height: auto;
         ">
    </details> 
        </ul>
    ''');
  }

  if (scenario.testResponse.extraScreenshots.map((e) => e.trim()).isNotEmpty) {
    images.add('''
       <ul> <details>
        <summary  style="color: $_whiteColor;
         font-size: 18px;
         font-weight: bold;
         cursor: pointer;
        ">Extra Images</summary >
        ${_getImageGallery(scenario.testResponse.extraScreenshots.where((e) => e.trim().isNotEmpty).toList())}
       
        
    </details> 
        </ul>
    ''');
  }

  return images.join('\r\n');
}

String _getImageGallery(List<String> images) {
  List<String> iString = [];

  iString.add('''
      <style>
        .image-container img {
            display: inline-block;
            margin-right: 10px; 
        }
    </style>
  
  <div class="image-container">
  ''');

  for (final i in images) {
    iString.add('''
      <img src="$i" alt="Image $i" style="width: 150px;">
    ''');
  }

  iString.add('''
  </div>
  ''');
  return iString.join('\r\n');
}

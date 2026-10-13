//
// import 'package:invently/assortment/helpers/db.dart';
// import 'package:invently/assortment/helpers/hive_helper.dart';
// import 'package:invently/assortment/helpers/secure_storage_helper.dart';
// import 'package:invently/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
//
// import 'helpers/test_utils.dart';
// import 'login/branch_selection_test.dart';
// import 'login/login_test.dart';
//
// void main() async {
//   await TestUtils.initTestUtils();
//
//   final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
//
//   WidgetsFlutterBinding.ensureInitialized();
//   SemanticsBinding.instance.ensureSemantics();
//
//   await SecureStorageHelper.clearAll();
//   HiveHelper.init(kIsWeb ? null : 'C:/Users/Public/Downloads');
//   await DB.clearAllDB();
//   await initApp();
//
//   /// --------------------- Write Module Tests Here --------------------
//   LoginTest.testModule();
//   BranchSelectionTest.testModule();
//
//   /// --------------------- Generate HTML --------------------
//   TestUtils.saveResults();
// }

// // Created by: Christo Pananjickal, Created at: 25-12-2024 04:13 pm
//
// import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
// import 'package:invently/gen/assets.gen.dart';
// import 'package:invently/gen/env.dart';
// import 'package:invently/ui/login/login/login_section.dart';
// import 'package:invently/ui/login/select_branch/select_branch_section.dart';
// import 'package:invently/ui/login/widgets/common_widgets.dart';
// import 'package:invently/widgets/text_widget/text_field.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import '../helpers/test_helper.dart';
// import '../helpers/test_utils.dart';
//
// class LoginTest {
//   static void testModule() {
//     TestHelper.testModule(
//       moduleName: 'Login module',
//       testCases: [
//         loginWithoutEmailAndPassword,
//         loginWithImproperEmail,
//         passwordVisibilityToggle(),
//         loginWithUnregisteredEmail,
//         loginWithValidEmailAndPassword,
//       ],
//     );
//   }
//
//   static TestCase loginWithoutEmailAndPassword = TestCase(
//     caseDescription: 'Login without email and password',
//     operations: [
//       TestUtils.initApp(),
//       _ensureVisible(),
//       _enterEmail(email: ''),
//       _enterPassword(password: ''),
//       _tapLogin(false),
//       TestUtils.textVisible(text: 'Email is required'),
//       TestUtils.textVisible(text: 'Password is required'),
//     ],
//   );
//
//   static TestCase loginWithImproperEmail = TestCase(
//     caseDescription: 'Login with improper email',
//     operations: [
//       TestUtils.initApp(),
//       _ensureVisible(),
//       _enterEmail(email: 'example@mail'),
//       _enterPassword(password: ''),
//       _tapLogin(false),
//       TestUtils.textVisible(text: 'Email is not a valid email'),
//       TestUtils.textVisible(text: 'Password is required'),
//     ],
//   );
//
//   static TestCase passwordVisibilityToggle() {
//     const fakePassword = '12345678';
//     return TestCase(
//       caseDescription: 'Password visibility toggle',
//       operations: [
//         TestUtils.initApp(),
//         _ensureVisible(),
//         _enterPassword(password: fakePassword),
//         _passwordVisible(hidden: true),
//         TestUtils.takeSnap(),
//         TestUtils.tapIconButton(icon: Assets.icons.eyeClosed),
//         _passwordVisible(hidden: false),
//         TestUtils.takeSnap(),
//         TestUtils.tapIconButton(icon: Assets.icons.eye),
//         _passwordVisible(hidden: true),
//       ],
//     );
//   }
//
//   static TestCase loginWithUnregisteredEmail = TestCase(
//     caseDescription: 'Login with unregistered email',
//     operations: [
//       TestUtils.initApp(),
//       _ensureVisible(),
//       _enterEmail(email: 'thisisaunregisted@mail.com'),
//       _enterPassword(password: '123456789'),
//       _tapLogin(true),
//       TestUtils.textVisible(text: 'Email or password is incorrect'),
//     ],
//   );
//
//   static TestCase loginWithValidEmailAndPassword = TestCase(
//     caseDescription: 'Login with valid email and password',
//     operations: [
//       TestUtils.initApp(),
//       ...loginFunction,
//       TestUtils.widgetVisible(widgetToFind: SelectBranchSection),
//       TestUtils.takeSnap(type: SnapType.success),
//       TestUtils.navigateTo(route: AppRoutes.login),
//     ],
//   );
//
//   static List<TestOperation> loginFunction = [
//     _ensureVisible(),
//     _enterEmail(email: Env.testEmail),
//     _enterPassword(password: Env.testPassword),
//     _tapLogin(true),
//   ];
//
//   static TestOperation _ensureVisible() => TestUtils.widgetVisible(widgetToFind: LoginSection);
//
//   static TestOperation _enterEmail({required String email}) =>
//       TestUtils.putText(widget: TextFieldWithTitle, text: 'Email', inputText: email);
//
//   static TestOperation _enterPassword({required String password}) =>
//       TestUtils.putText(widget: PasswordField, text: 'Password', inputText: password);
//
//   static TestOperation _tapLogin(bool loaderCheck) =>
//       TestUtils.tapTextButton(widget: StatsTextButton, text: 'Log In', loaderCheck: loaderCheck);
//
//   static TestOperation _passwordVisible({required bool hidden}) {
//     return TestOperation(
//       operationName: 'Check password is ${hidden ? 'hidden' : 'visible'}',
//       operation: (tester, scenario) {
//         dynamic state = tester.state(find.byType(PasswordField));
//         expect(state.obfuscate, hidden);
//       },
//     );
//   }
// }

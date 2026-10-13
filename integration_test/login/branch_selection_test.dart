// // Created by: Christo Pananjickal, Created at: 26-12-2024 06:41 pm
//
// import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
// import 'package:invently/gen/assets.gen.dart';
// import 'package:invently/ui/login/login/login_section.dart';
// import 'package:invently/ui/login/select_branch/select_branch_section.dart';
// import 'package:invently/ui/login/widgets/back_to_login_button.dart';
// import 'package:invently/ui/side_menu/side_menu.dart';
// import 'package:invently/widgets/buttons/rounded_rect_button.dart';
// import 'package:invently/widgets/custom_drop_down.dart';
// import 'package:invently/widgets/page_widgets/custom_scroll_bar.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import '../helpers/test_helper.dart';
// import '../helpers/test_utils.dart';
// import 'login_test.dart';
//
// class BranchSelectionTest {
//   static void testModule() {
//     TestHelper.testModule(
//       moduleName: 'Branch selection',
//       testCases: [
//         loginWithoutSelectingABranch,
//         goingBackToLogin,
//         loginBySelectingABranch,
//       ],
//     );
//   }
//
//   static TestCase loginWithoutSelectingABranch = TestCase(
//     caseDescription: 'Login without selecting a branch',
//     operations: [
//       ..._login,
//       _tapClearIcon,
//       _tapContinue,
//       TestUtils.textVisible(text: 'Please select any branch to continue'),
//       TestUtils.takeSnap(type: SnapType.success),
//       TestUtils.navigateTo(route: AppRoutes.login),
//     ],
//   );
//
//   static TestCase goingBackToLogin = TestCase(
//     caseDescription: 'Going back to login',
//     operations: [
//       ..._login,
//       _tapBackButton,
//       TestUtils.widgetVisible(widgetToFind: LoginSection),
//     ],
//   );
//
//   static TestCase loginBySelectingABranch = TestCase(
//     caseDescription: 'Login by selecting a branch',
//     operations: [
//       ..._login,
//       _tapDropdown,
//       TestUtils.dropdownOpened(),
//       TestOperation(
//         operationName: 'Scroll and select last item in list',
//         operation: (tester, s) async {
//           dynamic state = tester.state(find.byType(CustomDropdown));
//           final textOnLastItem = state.widget.items.value.last.value;
//           await TestUtils.scrollAndFind(
//             item: find.widgetWithText(DropDownTile, textOnLastItem),
//             list: find.byType(CustomScrollBar),
//           ).operation(tester, s);
//           await TestUtils.tapDropdownItem(label: textOnLastItem).operation(tester, s);
//           await TestUtils.textVisible(text: textOnLastItem).operation(tester, s);
//         },
//       ),
//       _tapContinue,
//       TestUtils.widgetVisible(widgetToFind: SideMenu),
//     ],
//   );
//
//   static final List<TestOperation> _login = [
//     TestUtils.initApp(),
//     TestUtils.navigateTo(route: AppRoutes.login),
//     ...LoginTest.loginFunction,
//     _ensureVisible,
//   ];
//
//   static final TestOperation _ensureVisible = TestUtils.widgetVisible(widgetToFind: SelectBranchSection);
//   static final TestOperation _tapContinue =
//       TestUtils.tapTextButton(widget: RRectButton, text: 'Continue', loaderCheck: false);
//   static final TestOperation _tapClearIcon = TestUtils.tapIconButton(icon: Assets.icons.close);
//   static final TestOperation _tapDropdown = TestUtils.tapDropdown(hint: 'Select branch');
//   static final TestOperation _tapBackButton = TestUtils.tapTextButton(widget: BackToLoginButton, text: 'Back to login');
// }


import 'package:invently/assortment/status.dart';
import 'package:invently/models/user/employee_model.dart';
import 'package:invently/network/employee_service.dart';
import 'package:invently/ui/master/employee/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class EmployeeProvider extends ChangeNotifier {
  Status employeeListStatus = Status.loading;

  List<UserModel> employeeList = [];

  String employeeListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  EmployeeFilterModel? filterModel;

  Future<void> getEmployeeList({int pageNumber = 1}) async {
    employeeListStatus = Status.loading;
    employeeList = [];
    totalCount = 0;
    employeeListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
        await EmployeeService.getEmployeeList(pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      employeeListStatus = Status.success;
      employeeList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      employeeListStatus = Status.error;
      employeeListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getEmployeeList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getEmployeeList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(EmployeeFilterModel? model) {
    filterModel = model;
    getEmployeeList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = employeeList.map((e) => e.selected).contains(false);
    for (final i in employeeList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(UserModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    employeeListStatus = Status.loading;
    employeeList = [];
    employeeListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

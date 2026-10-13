import 'package:invently/assortment/status.dart';
import 'package:invently/models/customer/customer_model.dart';
import 'package:invently/network/customer/customer_service.dart';
import 'package:invently/ui/master/customer/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class CustomerProvider extends ChangeNotifier {
  Status customerListStatus = Status.loading;

  List<CustomerModel> customerList = [];

  String customerListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  CustomerFilterModel? filterModel;

  Future<void> getCustomerList({int pageNumber = 1}) async {
    customerListStatus = Status.loading;
    customerList = [];
    totalCount = 0;
    customerListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
        await CustomerService.getCustomerList(pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      customerListStatus = Status.success;
      customerList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      customerListStatus = Status.error;
      customerListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getCustomerList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getCustomerList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(CustomerFilterModel? model) {
    filterModel = model;
    getCustomerList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = customerList.map((e) => e.selected).contains(false);
    for (final i in customerList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(CustomerModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    customerListStatus = Status.loading;
    customerList = [];
    customerListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

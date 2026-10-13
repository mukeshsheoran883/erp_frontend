import 'package:invently/assortment/status.dart';
import 'package:invently/models/customer/customer_quotation_model.dart';
import 'package:invently/network/customer/customer_quotation_service.dart';
import 'package:flutter/cupertino.dart';

class CustomerQuotationProvider extends ChangeNotifier {
  Status customerQuotationListStatus = Status.loading;

  List<CustomerQuotationModel> customerQuotationList = [];

  String customerQuotationListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  // BillHistoryFilterModel? filterModel;

  Future<void> getCustomerQuotationList({int pageNumber = 1}) async {
    customerQuotationListStatus = Status.loading;
    customerQuotationList = [];
    totalCount = 0;
    customerQuotationListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
    await CustomerQuotationService.getCustomerQuotationList( searchKey: searchKey, filter: null, pageNumber: pageNumber);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      customerQuotationListStatus = Status.success;
      customerQuotationList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      customerQuotationListStatus = Status.error;
      customerQuotationListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getCustomerQuotationList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getCustomerQuotationList(pageNumber: currentPage);
    notifyListeners();
  }

  // void applyFilter(BillHistoryFilterModel? model) {
  //   filterModel = model;
  //   getBillHistoryList(pageNumber: currentPage);
  //   notifyListeners();
  // }

  void selectAll() {
    final bool checkValue = customerQuotationList.map((e) => e.selected).contains(false);
    for (final i in customerQuotationList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(CustomerQuotationModel customerQuotation, bool value) {
    customerQuotation.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    customerQuotationListStatus = Status.loading;
    customerQuotationList = [];
    customerQuotationListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    // filterModel = null;
  }
}

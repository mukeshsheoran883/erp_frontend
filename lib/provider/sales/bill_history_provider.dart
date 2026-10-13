import 'package:invently/assortment/status.dart';
import 'package:invently/models/sales/bill_history_model.dart';
import 'package:invently/network/sales/bill_history_service.dart';
import 'package:invently/ui/sales/bill_history/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class BillHistoryProvider extends ChangeNotifier {
  Status billHistoryListStatus = Status.loading;

  List<BillHistoryModel> billHistoryList = [];

  String billHistoryListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  BillHistoryFilterModel? filterModel;

  Future<void> getBillHistoryList({int pageNumber = 1}) async {
    billHistoryListStatus = Status.loading;
    billHistoryList = [];
    totalCount = 0;
    billHistoryListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
        await BillHistoryService.getBillHistoryList(pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      billHistoryListStatus = Status.success;
      billHistoryList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      billHistoryListStatus = Status.error;
      billHistoryListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getBillHistoryList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getBillHistoryList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(BillHistoryFilterModel? model) {
    filterModel = model;
    getBillHistoryList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = billHistoryList.map((e) => e.selected).contains(false);
    for (final i in billHistoryList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(BillHistoryModel returnItem, bool value) {
    returnItem.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    billHistoryListStatus = Status.loading;
    billHistoryList = [];
    billHistoryListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

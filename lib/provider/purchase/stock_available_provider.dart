import 'package:invently/assortment/status.dart';
import 'package:invently/models/purchase/stock_available_model.dart';
import 'package:invently/network/stock_available_service.dart';
import 'package:invently/ui/purchase/returned_purchases/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class StockAvailableProvider extends ChangeNotifier {
  Status stockAvailableListStatus = Status.loading;

  List<StockAvailableModel> stockAvailableList = [];

  String stockAvailableListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  ReturnedPurchaseFilterModel? filterModel;

  Future<void> getStockAvailableList({int pageNumber = 1}) async {
    stockAvailableListStatus = Status.loading;
    stockAvailableList = [];
    totalCount = 0;
    stockAvailableListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await StockAvailableService.getStockAvailableList(
      pageNumber: currentPage, searchKey: searchKey,
      // filter: filterModel
    );

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      stockAvailableListStatus = Status.success;
      stockAvailableList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      stockAvailableListStatus = Status.error;
      stockAvailableListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getStockAvailableList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getStockAvailableList(pageNumber: currentPage);
    notifyListeners();
  }

  // void applyFilter(ReturnedPurchaseFilterModel? model) {
  //   filterModel = model;
  //   getReturnedPurchaseList(pageNumber: currentPage);
  //   notifyListeners();
  // }

  void selectAll() {
    final bool checkValue = stockAvailableList.map((e) => e.selected).contains(false);
    for (final i in stockAvailableList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(StockAvailableModel stockAvailable, bool value) {
    stockAvailable.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    stockAvailableListStatus = Status.loading;
    stockAvailableList = [];
    stockAvailableListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    // filterModel = null;
  }
}

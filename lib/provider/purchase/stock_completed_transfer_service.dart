import 'package:invently/assortment/status.dart';
import 'package:invently/models/purchase/stock_completed_transfer_model.dart';
import 'package:invently/network/stock_completed_transfer_service.dart';
import 'package:invently/ui/purchase/returned_purchases/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class StockCompletedTransferProvider extends ChangeNotifier {
  Status stockCompletedTransferListStatus = Status.loading;

  List<StockCompletedTransferModel> stockCompletedTransferList = [];

  String stockCompletedTransferListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  ReturnedPurchaseFilterModel? filterModel;

  Future<void> getStockCompletedTransferList({int pageNumber = 1}) async {
    stockCompletedTransferListStatus = Status.loading;
    stockCompletedTransferList = [];
    totalCount = 0;
    stockCompletedTransferListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await StockCompletedTransferService.getStockCompletedTransferList(
      pageNumber: currentPage, searchKey: searchKey,
      // filter: filterModel
    );

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      stockCompletedTransferListStatus = Status.success;
      stockCompletedTransferList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      stockCompletedTransferListStatus = Status.error;
      stockCompletedTransferListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getStockCompletedTransferList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getStockCompletedTransferList(pageNumber: currentPage);
    notifyListeners();
  }

  // void applyFilter(ReturnedPurchaseFilterModel? model) {
  //   filterModel = model;
  //   getReturnedPurchaseList(pageNumber: currentPage);
  //   notifyListeners();
  // }

  void selectAll() {
    final bool checkValue = stockCompletedTransferList.map((e) => e.selected).contains(false);
    for (final i in stockCompletedTransferList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(StockCompletedTransferModel stockCompletedTransfer, bool value) {
    stockCompletedTransfer.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    stockCompletedTransferListStatus = Status.loading;
    stockCompletedTransferList = [];
    stockCompletedTransferListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    // filterModel = null;
  }
}

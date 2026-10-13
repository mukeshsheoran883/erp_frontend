import 'package:invently/assortment/status.dart';
import 'package:invently/models/purchase/stock_pending_transfer_model.dart';
import 'package:invently/network/stock_pending_transfer_service.dart';
import 'package:invently/ui/purchase/returned_purchases/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class StockPendingTransferProvider extends ChangeNotifier {
  Status stockPendingTransferListStatus = Status.loading;

  List<StockPendingTransferModel> stockPendingTransferList = [];

  String stockPendingTransferListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  ReturnedPurchaseFilterModel? filterModel;

  Future<void> getStockPendingTransferList({int pageNumber = 1}) async {
    stockPendingTransferListStatus = Status.loading;
    stockPendingTransferList = [];
    totalCount = 0;
    stockPendingTransferListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await StockPendingTransferService.getStockPendingTransferList(
      pageNumber: currentPage, searchKey: searchKey,
      // filter: filterModel
    );

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      stockPendingTransferListStatus = Status.success;
      stockPendingTransferList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      stockPendingTransferListStatus = Status.error;
      stockPendingTransferListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getStockPendingTransferList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getStockPendingTransferList(pageNumber: currentPage);
    notifyListeners();
  }

  // void applyFilter(ReturnedPurchaseFilterModel? model) {
  //   filterModel = model;
  //   getReturnedPurchaseList(pageNumber: currentPage);
  //   notifyListeners();
  // }

  void selectAll() {
    final bool checkValue = stockPendingTransferList.map((e) => e.selected).contains(false);
    for (final i in stockPendingTransferList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(StockPendingTransferModel stockPendingTransfer, bool value) {
    stockPendingTransfer.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    stockPendingTransferListStatus = Status.loading;
    stockPendingTransferList = [];
    stockPendingTransferListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    // filterModel = null;
  }
}

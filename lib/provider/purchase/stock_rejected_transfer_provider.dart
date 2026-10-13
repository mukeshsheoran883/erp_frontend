import 'package:invently/assortment/status.dart';
import 'package:invently/models/purchase/stock_rejected_transfer_model.dart';
import 'package:invently/network/stock_rejected_transfer_service.dart';
import 'package:invently/ui/purchase/returned_purchases/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class StockRejectedTransferProvider extends ChangeNotifier {
  Status stockRejectedTransferListStatus = Status.loading;

  List<StockRejectedTransferModel> stockRejectedTransferList = [];

  String stockRejectedTransferListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  ReturnedPurchaseFilterModel? filterModel;

  Future<void> getStockRejectedTransferList({int pageNumber = 1}) async {
    stockRejectedTransferListStatus = Status.loading;
    stockRejectedTransferList = [];
    totalCount = 0;
    stockRejectedTransferListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await StockRejectedTransferService.getStockRejectedTransferList(
      pageNumber: currentPage, searchKey: searchKey,
      // filter: filterModel
    );

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      stockRejectedTransferListStatus = Status.success;
      stockRejectedTransferList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      stockRejectedTransferListStatus = Status.error;
      stockRejectedTransferListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getStockRejectedTransferList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getStockRejectedTransferList(pageNumber: currentPage);
    notifyListeners();
  }

  // void applyFilter(ReturnedPurchaseFilterModel? model) {
  //   filterModel = model;
  //   getReturnedPurchaseList(pageNumber: currentPage);
  //   notifyListeners();
  // }

  void selectAll() {
    final bool checkValue = stockRejectedTransferList.map((e) => e.selected).contains(false);
    for (final i in stockRejectedTransferList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(StockRejectedTransferModel stockRejectedTransfer, bool value) {
    stockRejectedTransfer.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    stockRejectedTransferListStatus = Status.loading;
    stockRejectedTransferList = [];
    stockRejectedTransferListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    // filterModel = null;
  }
}

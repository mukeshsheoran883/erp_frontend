import 'package:invently/assortment/status.dart';
import 'package:invently/models/purchase/returned_purchases_model.dart';
import 'package:invently/network/returned_purchases_service.dart';
import 'package:invently/ui/purchase/returned_purchases/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class ReturnedPurchasesProvider extends ChangeNotifier {
  Status returnedPurchaseListStatus = Status.loading;

  List<ReturnedPurchaseModel> returnedPurchaseList = [];

  String returnedPurchaseListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  ReturnedPurchaseFilterModel? filterModel;

  Future<void> getReturnedPurchaseList({int pageNumber = 1}) async {
    returnedPurchaseListStatus = Status.loading;
    returnedPurchaseList = [];
    totalCount = 0;
    returnedPurchaseListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await ReturnedPurchasesService.getReturnedPurchaseList(
        pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      returnedPurchaseListStatus = Status.success;
      returnedPurchaseList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      returnedPurchaseListStatus = Status.error;
      returnedPurchaseListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getReturnedPurchaseList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getReturnedPurchaseList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(ReturnedPurchaseFilterModel? model) {
    filterModel = model;
    getReturnedPurchaseList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = returnedPurchaseList.map((e) => e.selected).contains(false);
    for (final i in returnedPurchaseList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(ReturnedPurchaseModel purchase, bool value) {
    purchase.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    returnedPurchaseListStatus = Status.loading;
    returnedPurchaseList = [];
    returnedPurchaseListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

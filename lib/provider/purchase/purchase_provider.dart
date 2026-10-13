import 'package:invently/assortment/status.dart';
import 'package:invently/models/purchase/purchase_model.dart';
import 'package:invently/network/purchase_service.dart';
import 'package:invently/ui/purchase/purchase_list/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class PurchaseProvider extends ChangeNotifier {
  Status purchaseListStatus = Status.loading;

  List<PurchaseModel> purchaseList = [];

  String purchaseListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  PurchaseFilterModel? filterModel;

  Future<void> getPurchaseList({int pageNumber = 1}) async {
    purchaseListStatus = Status.loading;
    purchaseList = [];
    totalCount = 0;
    purchaseListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
        await PurchaseService.getPurchaseList(pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      purchaseListStatus = Status.success;
      purchaseList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      purchaseListStatus = Status.error;
      purchaseListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getPurchaseList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getPurchaseList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(PurchaseFilterModel? model) {
    filterModel = model;
    getPurchaseList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = purchaseList.map((e) => e.selected).contains(false);
    for (final i in purchaseList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(PurchaseModel purchase, bool value) {
    purchase.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    purchaseListStatus = Status.loading;
    purchaseList = [];
    purchaseListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

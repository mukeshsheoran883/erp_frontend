import 'package:invently/assortment/status.dart';
import 'package:invently/models/sales/return_item_model.dart';
import 'package:invently/network/sales/return_item_service.dart';
import 'package:invently/ui/sales/return_item/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class ReturnItemProvider extends ChangeNotifier {
  Status returnItemListStatus = Status.loading;

  List<ReturnItemModel> returnItemList = [];

  String returnItemListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  ReturnItemFilterModel? filterModel;

  Future<void> getReturnItemList({int pageNumber = 1}) async {
    returnItemListStatus = Status.loading;
    returnItemList = [];
    totalCount = 0;
    returnItemListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
        await ReturnItemService.getReturnItemList(pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      returnItemListStatus = Status.success;
      returnItemList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      returnItemListStatus = Status.error;
      returnItemListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getReturnItemList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getReturnItemList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(ReturnItemFilterModel? model) {
    filterModel = model;
    getReturnItemList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = returnItemList.map((e) => e.selected).contains(false);
    for (final i in returnItemList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(ReturnItemModel returnItem, bool value) {
    returnItem.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    returnItemListStatus = Status.loading;
    returnItemList = [];
    returnItemListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

import 'package:invently/assortment/status.dart';
import 'package:invently/models/customer/customer_model.dart';
import 'package:invently/models/inventory/inventory_model.dart';
import 'package:invently/network/customer/customer_service.dart';
import 'package:invently/network/inventory/inventory_service.dart';
import 'package:invently/ui/master/customer/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class InventoryProvider extends ChangeNotifier {
  Status inventoryListStatus = Status.loading;

  List<InventoryModel> inventoryList = [];

  String inventoryListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  CustomerFilterModel? filterModel;

  Future<void> getInventoryList({int pageNumber = 1}) async {
    inventoryListStatus = Status.loading;
    inventoryList = [];
    totalCount = 0;
    inventoryListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
    await InventoryService.getInventoryList(pageNumber: currentPage, searchKey: searchKey,);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      inventoryListStatus = Status.success;
      inventoryList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      inventoryListStatus = Status.error;
      inventoryListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getInventoryList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getInventoryList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(CustomerFilterModel? model) {
    filterModel = model;
    getInventoryList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = inventoryList.map((e) => e.selected).contains(false);
    for (final i in inventoryList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(InventoryModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    inventoryListStatus = Status.loading;
    inventoryList = [];
    inventoryListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

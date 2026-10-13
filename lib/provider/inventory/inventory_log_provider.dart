import 'package:invently/assortment/status.dart';
import 'package:invently/models/customer/customer_model.dart';
import 'package:invently/models/inventory/inventory_model.dart';
import 'package:invently/network/customer/customer_service.dart';
import 'package:invently/network/inventory/inventory_service.dart';
import 'package:invently/ui/master/customer/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class InventoryLogProvider extends ChangeNotifier {
  Status inventoryLogListStatus = Status.loading;

  List<InventoryLogModel> inventoryLogList = [];

  String inventoryLogListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  CustomerFilterModel? filterModel;

  Future<void> getInventoryLogList({int pageNumber = 1}) async {
    inventoryLogListStatus = Status.loading;
    inventoryLogList = [];
    totalCount = 0;
    inventoryLogListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
    await InventoryService.getInventoryLog();

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      inventoryLogListStatus = Status.success;
      inventoryLogList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      inventoryLogListStatus = Status.error;
      inventoryLogListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getInventoryLogList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getInventoryLogList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(CustomerFilterModel? model) {
    filterModel = model;
    getInventoryLogList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = inventoryLogList.map((e) => e.selected).contains(false);
    for (final i in inventoryLogList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(InventoryModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    inventoryLogListStatus = Status.loading;
    inventoryLogList = [];
    inventoryLogListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

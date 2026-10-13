import 'package:invently/assortment/status.dart';
import 'package:invently/models/supplier/supplier_model.dart';
import 'package:invently/network/supplier_service.dart';
import 'package:invently/ui/master/supplier/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class SupplierProvider extends ChangeNotifier {
  Status supplierListStatus = Status.loading;

  List<SupplierModel> supplierList = [];

  String supplierListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  SupplierFilterModel? filterModel;

  Future<void> getSupplierList({int pageNumber = 1}) async {
    supplierListStatus = Status.loading;
    supplierList = [];
    totalCount = 0;
    supplierListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
        await SupplierService.getSupplierList(pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      supplierListStatus = Status.success;
      supplierList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      supplierListStatus = Status.error;
      supplierListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getSupplierList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getSupplierList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(SupplierFilterModel? model) {
    filterModel = model;
    getSupplierList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = supplierList.map((e) => e.selected).contains(false);
    for (final i in supplierList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(SupplierModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    supplierListStatus = Status.loading;
    supplierList = [];
    supplierListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

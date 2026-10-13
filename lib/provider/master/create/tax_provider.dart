import 'package:invently/assortment/status.dart';
import 'package:invently/models/tax/tax_model.dart';
import 'package:invently/network/tax_service.dart';
import 'package:flutter/cupertino.dart';

class TaxProvider extends ChangeNotifier {
  Status taxListStatus = Status.loading;

  List<TaxModel> taxList = [];

  String taxListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';

  Future<void> getTaxList({int pageNumber = 1}) async {
    taxListStatus = Status.loading;
    taxList = [];
    totalCount = 0;
    taxListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await TaxService.getTaxList(pageNumber: currentPage, searchKey: searchKey);

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      taxListStatus = Status.success;
      taxList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      taxListStatus = Status.error;
      taxListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getTaxList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getTaxList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = taxList.map((e) => e.selected).contains(false);
    for (final i in taxList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(TaxModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clear() {
    taxListStatus = Status.loading;
    taxList = [];
    taxListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
  }

  void clearProvider() {}
}

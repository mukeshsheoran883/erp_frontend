import 'package:invently/assortment/status.dart';
import 'package:invently/models/brand/brand_model.dart';
import 'package:invently/network/brand_service.dart';
import 'package:flutter/cupertino.dart';

class BrandProvider extends ChangeNotifier {
  Status brandListStatus = Status.loading;

  List<BrandModel> brandList = [];

  String brandListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';

  Future<void> getBrandList({int pageNumber = 1}) async {
    brandListStatus = Status.loading;
    brandList = [];
    totalCount = 0;
    brandListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await BrandService.getBrandList(pageNumber: currentPage, searchKey: searchKey);

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      brandListStatus = Status.success;
      brandList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      brandListStatus = Status.error;
      brandListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getBrandList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getBrandList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = brandList.map((e) => e.selected).contains(false);
    for (final i in brandList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(BrandModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clear() {
    brandListStatus = Status.loading;
    brandList = [];
    brandListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
  }

  void clearProvider() {}
}

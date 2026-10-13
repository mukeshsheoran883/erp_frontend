import 'package:invently/assortment/status.dart';
import 'package:invently/models/category/category_model.dart';
import 'package:invently/network/category_service.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier {
  Status categoryListStatus = Status.loading;

  List<CategoryModel> categoryList = [];

  String categoryListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';

  Future<void> getCategoryList({int pageNumber = 1}) async {
    categoryListStatus = Status.loading;
    categoryList = [];
    totalCount = 0;
    categoryListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await CategoryService.getCategoryList(pageNumber: currentPage, searchKey: searchKey);

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      categoryListStatus = Status.success;
      categoryList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      categoryListStatus = Status.error;
      categoryListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getCategoryList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getCategoryList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = categoryList.map((e) => e.selected).contains(false);
    for (final i in categoryList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(CategoryModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clear() {
    categoryListStatus = Status.loading;
    categoryList = [];
    categoryListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
  }

  void clearProvider() {}
}

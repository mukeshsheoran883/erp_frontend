import 'package:invently/assortment/status.dart';
import 'package:invently/models/items/item_model.dart';
import 'package:invently/network/item_service.dart';
import 'package:invently/ui/master/items/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class ItemProvider extends ChangeNotifier {
  Status itemListStatus = Status.loading;

  List<ItemModel> itemList = [];

  String itemListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  ItemFilterModel? filterModel;

  Future<void> getItemList({int pageNumber = 1}) async {
    itemListStatus = Status.loading;
    itemList = [];
    totalCount = 0;
    itemListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await ItemService.getItemsList(pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      itemListStatus = Status.success;
      itemList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      itemListStatus = Status.error;
      itemListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getItemList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getItemList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(ItemFilterModel? model) {
    filterModel = model;
    getItemList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = itemList.map((e) => e.selected).contains(false);
    for (final i in itemList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(ItemModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    itemListStatus = Status.loading;
    itemList = [];
    itemListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

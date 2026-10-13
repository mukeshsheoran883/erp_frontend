import 'package:invently/assortment/status.dart';
import 'package:invently/models/pos/pos_model.dart';
import 'package:invently/network/pos/pos_service.dart';
import 'package:flutter/cupertino.dart';

class DispatchProvider extends ChangeNotifier {
  Status posListStatus = Status.loading;

  List<PosModel> posList = [];

  String posListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';

  // SupplierFilterModel? filterModel;

  Future<void> getDispatchList({int pageNumber = 1}) async {
    posListStatus = Status.loading;
    posList = [];
    totalCount = 0;
    posListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await PosService.getPosList(
      pageNumber: currentPage,
      searchKey: searchKey,
      status: 'dispatch_pending',
    );

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      posListStatus = Status.success;
      posList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      posListStatus = Status.error;
      posListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getDispatchList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getDispatchList(pageNumber: currentPage);
    notifyListeners();
  }

  // void applyFilter(SupplierFilterModel? model) {
  //   filterModel = model;
  //   getSupplierList(pageNumber: currentPage);
  //   notifyListeners();
  // }

  void selectAll() {
    final bool checkValue = posList.map((e) => e.selected).contains(false);
    for (final i in posList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(PosModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    posListStatus = Status.loading;
    posList = [];
    posListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    // filterModel = null;
  }
}

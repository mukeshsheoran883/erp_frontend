import 'package:invently/assortment/status.dart';
import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/ui/master/branch/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class BranchProvider extends ChangeNotifier {
  Status branchListStatus = Status.loading;

  List<BranchModel> branchList = [];

  String branchListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  BranchFilterModel? filterModel;

  Future<void> getBranchList({int pageNumber = 1}) async {
    branchListStatus = Status.loading;
    branchList = [];
    totalCount = 0;
    branchListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response =
        await BranchService.getBranchList(pageNumber: currentPage, searchKey: searchKey, filter: filterModel);

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      branchListStatus = Status.success;
      branchList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      branchListStatus = Status.error;
      branchListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getBranchList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getBranchList(pageNumber: currentPage);
    notifyListeners();
  }

  void applyFilter(BranchFilterModel? model) {
    filterModel = model;
    getBranchList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = branchList.map((e) => e.selected).contains(false);
    for (final i in branchList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(BranchModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    branchListStatus = Status.loading;
    branchList = [];
    branchListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    filterModel = null;
  }
}

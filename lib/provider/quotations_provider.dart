import 'package:invently/assortment/status.dart';
import 'package:invently/models/quotations/quotations_model.dart';
import 'package:invently/network/quotations/quotations_service.dart';
import 'package:invently/ui/purchase/returned_purchases/widgets/filter_section.dart';
import 'package:flutter/cupertino.dart';

class QuotationsProvider extends ChangeNotifier {
  Status quotationsListStatus = Status.loading;

  List<QuotationsModel> quotationsList = [];

  String quotationsListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';
  ReturnedPurchaseFilterModel? filterModel;

  Future<void> getQuotationsList({int pageNumber = 1}) async {
    quotationsListStatus = Status.loading;
    quotationsList = [];
    totalCount = 0;
    quotationsListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await QuotationsService.getQuotationsList(
      pageNumber: currentPage, searchKey: searchKey,
      // filter: filterModel
    );

    if (currentPage != pageNumber || response.searchText != searchKey) return;

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      quotationsListStatus = Status.success;
      quotationsList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      quotationsListStatus = Status.error;
      quotationsListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getQuotationsList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getQuotationsList(pageNumber: currentPage);
    notifyListeners();
  }

  // void applyFilter(ReturnedPurchaseFilterModel? model) {
  //   filterModel = model;
  //   getReturnedPurchaseList(pageNumber: currentPage);
  //   notifyListeners();
  // }

  void selectAll() {
    final bool checkValue = quotationsList.map((e) => e.selected).contains(false);
    for (final i in quotationsList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(QuotationsModel quotations, bool value) {
    quotations.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    quotationsListStatus = Status.loading;
    quotationsList = [];
    quotationsListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
    // filterModel = null;
  }
}

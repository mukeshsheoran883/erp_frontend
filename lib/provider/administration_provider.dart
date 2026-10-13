import 'package:invently/assortment/status.dart';
import 'package:invently/models/administration/organization_model.dart';
import 'package:invently/network/administration_service.dart';
import 'package:flutter/cupertino.dart';

class AdministrationProvider extends ChangeNotifier {
  Status organizationListStatus = Status.loading;

  List<AdministrationModel> organizationList = [];

  String organizationListingError = '';
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  String searchKey = '';

  Future<void> getOrganizationList({int pageNumber = 1}) async {
    organizationListStatus = Status.loading;
    organizationList = [];
    totalCount = 0;
    organizationListingError = '';
    currentPage = pageNumber;
    notifyListeners();

    final response = await AdministrationService.getOrganizationList(pageNumber: currentPage, searchKey: searchKey);

    if (response.responseType.success && response.data != null) {
      if (currentPage != pageNumber) return;
      organizationListStatus = Status.success;
      organizationList = response.data!;
      totalPages = response.totalPage;
      currentPage = response.currentPage;
      totalCount = response.totalCount;
      showingCount = response.data!.length;
    } else {
      organizationListStatus = Status.error;
      organizationListingError = response.firstError();
    }
    notifyListeners();
  }

  void changePage(int number) {
    if (currentPage == number || number > totalPages || number < 1) return;
    currentPage = number;
    getOrganizationList(pageNumber: number);
    notifyListeners();
  }

  void search(String search) {
    currentPage = 1;
    searchKey = search;
    getOrganizationList(pageNumber: currentPage);
    notifyListeners();
  }

  void selectAll() {
    final bool checkValue = organizationList.map((e) => e.selected).contains(false);
    for (final i in organizationList) {
      i.selected = checkValue;
    }
    notifyListeners();
  }

  void selectItem(AdministrationModel item, bool value) {
    item.selected = value;
    notifyListeners();
  }

  void clearProvider() {
    organizationListStatus = Status.loading;
    organizationList = [];
    organizationListingError = '';
    currentPage = 0;
    totalPages = 0;
    totalCount = 0;
    showingCount = 0;
    searchKey = '';
  }
}

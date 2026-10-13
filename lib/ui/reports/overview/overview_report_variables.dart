import 'package:invently/assortment/status.dart';

class OverviewReportVariables<T> {
  int currentPage = 1;
  int totalPages = 0;
  int showingCount = 0;
  int totalCount = 0;
  Status listingStatus = Status.loading;
  String listingError = '';
  List<T> reportsList = [];
  Function(int page)? onSubmit;

  void clear() {
    currentPage = 1;
    totalPages = 0;
    showingCount = 0;
    totalCount = 0;
    listingStatus = Status.loading;
    reportsList = [];
    listingError = '';
  }
}

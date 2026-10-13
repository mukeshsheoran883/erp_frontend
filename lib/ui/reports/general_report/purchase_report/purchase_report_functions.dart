
part of 'purchase_report_screen.dart';

Future<void> _getPurchaseReport(_PurchaseReportScreenListingState state, {int pageNumber = 1}) async {
  state.provider.validateFn?.call();

  GeneralReportVariables<PurchaseReportModel> param = state.param;

  param.listingStatus = Status.loading;
  param.reportsList = [];
  param.listingError = '';
  param.totalCount = 0;
  param.currentPage = pageNumber;
  state._refresh();
  state.provider.refresh();

  if (state.provider.startDate.dateTime == null ||
      state.provider.startDate.error.isError ||
      state.provider.endDate.dateTime == null ||
      state.provider.endDate.error.isError) {
    state.provider.startDate.reset(DateTime.now());
    state.provider.endDate.reset(DateTime.now());
  }

  final response = await GeneralReportService.getPurchaseReportList(
    pageNumber: param.currentPage,
    startDate: state.provider.startDate.dateTime!,
    endDate: state.provider.endDate.dateTime!,
  );

  if (response.isSuccess()) {
    if (param.currentPage != pageNumber) return;
    param.listingStatus = Status.success;
    param.reportsList = response.data!;
    param.totalPages = response.totalPage;
    param.currentPage = response.currentPage;
    param.totalCount = response.totalCount;
    param.showingCount = response.data!.length;
  } else {
    param.listingStatus = Status.error;
    param.listingError = response.firstError();
  }
  state._refresh();
  state.provider.refresh();
}

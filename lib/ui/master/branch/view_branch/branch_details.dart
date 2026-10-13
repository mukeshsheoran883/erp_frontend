part of '../branch_screen.dart';

class BranchDetails extends StatefulWidget {
  final String shopCode;

  const BranchDetails({super.key, required this.shopCode});

  @override
  State<BranchDetails> createState() => _BranchDetailsState();
}

class _BranchDetailsState extends State<BranchDetails> {
  Status branchStatus = Status.loading;
  String? error;
  BranchModel? branch;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getBranch());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewDetailsSkeleton(
      title: 'Branch Details',
      error: error,
      onRetry: _getBranch,
      status: branchStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(label: 'Name', childText: branch!.name.toFirstLetterUpperCase()),
                DetailsValueName(label: 'Type', childText: branch!.type.toFirstLetterUpperCase()),
                DetailsValueName(label: 'Country', childText: branch!.country),
                DetailsValueName(label: 'State', childText: branch!.state),
                DetailsValueName(label: 'Street', childText: branch!.street),
                DetailsValueName(
                  label: 'Phone',
                  childText: StaticValues.mobileFormatter(
                    code: branch!.mobileNumberDailCode,
                    number: branch!.mobileNumber,
                  ),
                ),
                DetailsValueName(
                  label: 'Alternative Phone :',
                  childText: StaticValues.mobileFormatter(
                    code: branch!.altMobileNumberDailCode,
                    number: branch!.altMobileNumber,
                  ),
                ),
                DetailsValueName(label: 'Website', childText: branch!.website),
              ],
            ),
          ),
        );
      },
      bottomButtons: branchStatus == Status.success
          ? [
              ViewDetailsButtonModel.closeButton(),
              ViewDetailsButtonModel.deleteButton(() async {
                bool deleted = await _deleteBranches([branch!]);
                if (deleted) AppNavigator.pop();
              }),
              ViewDetailsButtonModel.editButton(() {
                AppNavigator.pop();
                AppNavigator.navigate(
                  AppRoutes.branchEdit(data: AddEditBranchScreen(shopCode: widget.shopCode)),
                );
              }),
            ]
          : [],
    );
  }

  Future<void> _getBranch() async {
    branchStatus = Status.loading;
    error = null;
    branch = null;
    _refresh();

    final response = await BranchService.getBranch(branchCode: widget.shopCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      branchStatus = Status.error;
      _refresh();
      return;
    }

    branch = response.data;
    branchStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

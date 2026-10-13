part of '../tax_screen.dart';

class TaxDetails extends StatefulWidget {
  final String taxCode;

  const TaxDetails({super.key, required this.taxCode});

  @override
  State<TaxDetails> createState() => _TaxDetailsState();
}

class _TaxDetailsState extends State<TaxDetails> {
  Status taxStatus = Status.loading;
  String? error;
  TaxModel? tax;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getTax());
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
      title: 'Tax Details',
      error: error,
      onRetry: _getTax,
      status: taxStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(label: 'Name', childText: tax!.name.toFirstLetterUpperCase()),
              ],
            ),
          ),
        );
      },
      bottomButtons: taxStatus == Status.success
          ? [
              ViewDetailsButtonModel.closeButton(),
              ViewDetailsButtonModel.deleteButton(() async {
                bool deleted = await _deleteTax([tax!]);
                if (deleted) AppNavigator.pop();
              }),
              // ViewDetailsButtonModel.editButton(() {
              //   AppNavigator.pop();
              //   AppNavigator.navigate(
              //     AppRoutes.branchEdit(data: AddEditBranchScreen(shopCode: widget.taxCode)),
              //   );
              // }),
            ]
          : [],
    );
  }

  Future<void> _getTax() async {
    taxStatus = Status.loading;
    error = null;
    tax = null;
    _refresh();

    final response = await TaxService.getTax(taxCode: widget.taxCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      taxStatus = Status.error;
      _refresh();
      return;
    }

    tax = response.data;
    taxStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

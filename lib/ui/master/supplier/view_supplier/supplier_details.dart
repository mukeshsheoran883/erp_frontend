part of '../supplier_screen.dart';

class SupplierDetails extends StatefulWidget {
  final String supplierCode;

  const SupplierDetails({super.key, required this.supplierCode});

  @override
  State<SupplierDetails> createState() => _SupplierDetailsState();
}

class _SupplierDetailsState extends State<SupplierDetails> {
  Status suppliersStatus = Status.loading;
  String? error;
  SupplierModel? suppliers;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getSuppliers());
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
      title: 'Suppliers Details',
      error: error,
      onRetry: _getSuppliers,
      status: suppliersStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DetailsValueName(
                        label: 'Supplier Image',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: CachedImage(
                            url: suppliers!.profilePhotoUrl,
                            height: 140,
                            width: 140,
                            errorWidget: Container(
                              width: 140,
                              height: 140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Tm.color(Tc.tableLine2)),
                              child: SvgImage(Assets.icons.person, height: 40, width: 40, color: Tm.color(Tc.txtH4)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DetailsValueName(
                        label: 'ID Proof',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: CachedImage(
                            url: suppliers!.idProofUrl,
                            height: 140,
                            width: 140,
                            errorWidget: Container(
                              width: 140,
                              height: 140,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Tm.color(Tc.tableLine2)),
                              child: SvgImage(Assets.icons.person, height: 40, width: 40, color: Tm.color(Tc.txtH4)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                DetailsValueName(label: 'Name', childText: suppliers!.name.toFirstLetterUpperCase()),
                DetailsValueName(label: 'Email', childText: suppliers!.emailId),
                DetailsValueName(
                  label: 'Phone',
                  childText: StaticValues.mobileFormatter(
                    code: suppliers!.mobileNumberDailCode,
                    number: suppliers!.mobileNumber,
                  ),
                ),
                DetailsValueName(
                  label: 'Alternative Phone',
                  childText: StaticValues.mobileFormatter(
                    code: suppliers!.altMobileNumberDailCode,
                    number: suppliers!.altMobileNumber,
                  ),
                ),
                DetailsValueName(label: 'Address', childText: suppliers!.address),
                DetailsValueName(label: 'Country', childText: suppliers!.country),
                DetailsValueName(label: 'State of Province', childText: suppliers!.state),
                DetailsValueName(
                  label: 'ID Unique Number',
                  childText: '${suppliers!.idType.toFirstLetterUpperCase()}: ${suppliers!.idNumber}',
                ),
                DetailsValueName(label: 'GST Number', childText: suppliers!.gstNumber),
              ],
            ),
          ),
        );
      },
      bottomButtons: suppliersStatus == Status.success
          ? [
              ViewDetailsButtonModel.closeButton(),
              ViewDetailsButtonModel.deleteButton(() async {
                bool deleted = await _deleteSupplier([suppliers!]);
                if (deleted) AppNavigator.pop();
              }),
              ViewDetailsButtonModel.editButton(() {
                AppNavigator.pop();
                AppNavigator.navigate(
                  AppRoutes.suppliersEdit(data: AddEditSupplierScreen(supplierCode: widget.supplierCode)),
                );
              }),
            ]
          : [],
    );
  }

  Future<void> _getSuppliers() async {
    suppliersStatus = Status.loading;
    error = null;
    suppliers = null;
    _refresh();

    final response = await SupplierService.getSupplier(suppliersCode: widget.supplierCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      suppliersStatus = Status.error;
      _refresh();
      return;
    }

    suppliers = response.data;
    suppliersStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

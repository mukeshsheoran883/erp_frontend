part of '../administration_screen.dart';

class AdministrationDetails extends StatefulWidget {
  final String administrationCode;

  const AdministrationDetails({super.key, required this.administrationCode});

  @override
  State<AdministrationDetails> createState() => _AdministrationDetails();
}

class _AdministrationDetails extends State<AdministrationDetails> {
  Status administrationStatus = Status.loading;
  String? error;
  AdministrationModel? administration;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getAdministrations());
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
      title: 'Administration Details',
      error: error,
      onRetry: _getAdministrations,
      status: administrationStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(
                  label: 'Id Proof',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: CachedImage(
                      url: administration!.imageUrl,
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
                DetailsValueName(label: 'Company Name', childText: administration!.name.toFirstLetterUpperCase()),
                DetailsValueName(
                  label: 'Contact Person Name',
                  childText: administration!.contactPersonName.toFirstLetterUpperCase(),
                ),
                DetailsValueName(label: 'Contact Email', childText: administration!.email),
                DetailsValueName(
                  label: 'Phone',
                  childText: StaticValues.mobileFormatter(
                    code: administration!.mobileNumberDailCode,
                    number: administration!.mobileNumber,
                  ),
                ),
                DetailsValueName(
                  label: 'Alternate Phone',
                  childText: StaticValues.mobileFormatter(
                    code: administration!.altMobileNumberDailCode,
                    number: administration!.altMobileNumber,
                  ),
                ),
                DetailsValueName(label: 'Plan', childText: administration!.plan),
                DetailsValueName(label: 'Branch Count', childText: administration!.shopCount.toString()),
                DetailsValueName(label: 'User Count', childText: administration!.employeeCount.toString()),
                DetailsValueName(
                  label: 'Expire Date',
                  childText: StaticValues.commonDateFormatSlash.format(administration!.planExpiry),
                ),
                DetailsValueName(label: 'Payment Gateway', childText: administration!.paymentGateway.toString()),
                DetailsValueName(label: 'Approval', childText: administration!.approval.toString()),
              ],
            ),
          ),
        );
      },
      bottomButtons: administrationStatus == Status.success
          ? [
              ViewDetailsButtonModel.closeButton(),
              ViewDetailsButtonModel.deleteButton(() async {
                bool deleted = await _deleteAdministration([administration!]);
                if (deleted) AppNavigator.pop();
              }),
              ViewDetailsButtonModel.editButton(() {
                AppNavigator.pop();
                AppNavigator.navigate(
                  AppRoutes.administrationEdit(
                    data: AddEditAdministrationScreen(administrationCode: administration!.name),
                  ),
                );
              }),
            ]
          : [],
    );
  }

  Future<void> _getAdministrations() async {
    administrationStatus = Status.loading;
    error = null;
    administration = null;
    _refresh();

    final response = await AdministrationService.getOrganization(organizationName: widget.administrationCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      administrationStatus = Status.error;
      _refresh();
      return;
    }

    administration = response.data;
    administrationStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

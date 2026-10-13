part of '../customer_screen.dart';

class CustomerDetails extends StatefulWidget {
  final String customerCode;

  const CustomerDetails({super.key, required this.customerCode});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  Status customerStatus = Status.loading;
  String? error;
  CustomerModel? customer;
  late ScrollController scrollController;
  List<String> permissionList = [];

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getCustomer());
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
      title: 'Customer Details',
      error: error,
      onRetry: _getCustomer,
      status: customerStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(label: 'Name', childText: customer!.name.toFirstLetterUpperCase()),
                DetailsValueName(label: 'Email', childText: customer!.emailId),
                DetailsValueName(
                  label: 'Phone',
                  childText: StaticValues.mobileFormatter(
                    code: customer!.mobileNumberDailCode,
                    number: customer!.mobileNumber,
                  ),
                ),
                DetailsValueName(label: 'ID Unique Number', childText: '${customer!.idType}: ${customer!.idNumber}'),
                DetailsValueName(label: 'Organisation Name', childText: customer!.organisationName),
                DetailsValueName(label: 'Occupation', childText: customer!.occupation),
                DetailsValueName(
                  label: 'Date of Birth',
                  childText: StaticValues.commonDateFormatSlash.format(customer!.dateOfBirth),
                ),
                DetailsValueName(label: 'Education', childText: customer!.education),
                DetailsValueName(label: 'Religion', childText: customer!.religion),
                DetailsValueName(label: 'Blood group', childText: customer!.bloodGroup),
                DetailsValueName(label: 'Marital Status', childText: customer!.martialStatus),
                DetailsValueName(
                  label: 'Added Date & Time',
                  childText: StaticValues.commonDateFormatSlash.format(customer!.createdDateTime),
                ),
                DetailsValueName(label: 'Country', childText: customer!.country),
                DetailsValueName(label: 'State of Province', childText: customer!.state),
                DetailsValueName(label: 'Address', childText: customer!.street),
              ],
            ),
          ),
        );
      },
      bottomButtons: customerStatus == Status.success
          ? [
              ViewDetailsButtonModel.closeButton(),
              ViewDetailsButtonModel.deleteButton(() async {
                bool deleted = await _deleteCustomer([customer!]);
                if (deleted) AppNavigator.pop();
              }),
              ViewDetailsButtonModel.editButton(() {
                AppNavigator.pop();
                AppNavigator.navigate(
                  AppRoutes.customersEdit(data: AddEditCustomerScreen(customerCode: widget.customerCode)),
                );
              }),
            ]
          : [],
    );
  }

  Future<void> _getCustomer() async {
    customerStatus = Status.loading;
    error = null;
    customer = null;
    _refresh();

    final response = await CustomerService.getCustomer(customerCode: widget.customerCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      customerStatus = Status.error;
      _refresh();
      return;
    }

    customer = response.data;
    customerStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

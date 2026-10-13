part of '../inventory_screen.dart';

class InventoryDetails extends StatefulWidget {
  final String inventoryCode;
  final String inventoryName;

  const InventoryDetails({super.key, required this.inventoryCode, required this.inventoryName});

  @override
  State<InventoryDetails> createState() => _InventoryDetails();
}

class _InventoryDetails extends State<InventoryDetails> {
  Status inventoryStatus = Status.loading;
  String? error;
  InventoryModel? inventory;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getInventoryDetails());
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
      title: 'Inventory Details',
      error: error,
      onRetry: _getInventoryDetails,
      status: inventoryStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(label: 'Inventory Code', childText: inventory!.inventoryCode),
                DetailsValueName(label: 'Item Name', childText: inventory!.itemName),
                DetailsValueName(label: 'Item Code', childText: inventory!.itemCode),
                DetailsValueName(label: 'Description', childText: inventory!.description),
                DetailsValueName(label: 'Shop Name', childText: inventory!.shopName),
                DetailsValueName(label: 'Store Mapping', childText: inventory!.storeMapping),
                DetailsValueName(
                  label: 'Expiry Date',
                  childText: StaticValues.commonDateFormatSlash.format(inventory!.expiryDate),
                ),
                DetailsValueName(label: 'Price', childText: inventory!.price.toString()),
                DetailsValueName(label: 'Balance Quantity', childText: inventory!.balanceQty.toString()),
                DetailsValueName(
                  label: 'Created Time',
                  childText: StaticValues.commonDateFormatSlash.format(inventory!.createdTime),
                ),
              ],
            ),
          ),
        );
      },
      bottomButtons: inventoryStatus == Status.success
          ? [
        ViewDetailsButtonModel.closeButton(),
        ViewDetailsButtonModel.deleteButton(() async {
          // bool deleted = await _deleteInventory([inventory!]);
          // if (deleted) AppNavigator.pop();
        }),
        ViewDetailsButtonModel.editButton(() {
          AppNavigator.pop();
          AppNavigator.navigate(
            AppRoutes.inventoryEdit(
              data: AddEditInventoryScreen(inventoryCode: inventory!.inventoryCode, inventoryName: inventory!.inventoryId.toString(),),
            ),
          );
        }),
      ]
          : [],
    );
  }

  Future<void> _getInventoryDetails() async {
    inventoryStatus = Status.loading;
    error = null;
    inventory = null;
    _refresh();

    final response = await InventoryService.getInventory(inventoryName: widget.inventoryCode, inventoryCode: widget.inventoryCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      inventoryStatus = Status.error;
      _refresh();
      return;
    }

    inventory = response.data;
    inventoryStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
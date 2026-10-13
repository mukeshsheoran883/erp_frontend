part of '../items_screen.dart';

class ItemsDetails extends StatefulWidget {
  final String itemCode;

  const ItemsDetails({super.key, required this.itemCode});

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  Status itemsStatus = Status.loading;
  String? error;
  ItemModel? items;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((s) => _getItems());
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
      title: 'Items Details',
      error: error,
      onRetry: _getItems,
      status: itemsStatus,
      builder: (context) {
        return CustomScrollBar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsValueName(
                  label: 'Item Image',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: CachedImage(
                      url: items!.imageUrl,
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
                DetailsValueName(label: 'Item Name', childText: items!.name.toFirstLetterUpperCase()),
                DetailsValueName(label: 'Description', childText: items!.description),
                DetailsValueName(label: 'Brand', childText: items!.brandName),
                DetailsValueName(label: 'Category', childText: items!.categoryName),
                DetailsValueName(label: 'Supplier', childText: items!.supplierName),
                DetailsValueName(label: 'Tax', childText: items!.taxName),
                DetailsValueName(label: 'HSN Code', childText: items!.hsnCode),
                DetailsValueName(label: 'QR Code', childText: items!.barQrCode),
                DetailsValueName(label: 'SKU Code', childText: items!.skuCode),
                DetailsValueName(label: 'No. of Packets', childText: items!.noOfPackets.toString()),
                DetailsValueName(label: 'Plain Price', childText: items!.plainPrice.toString()),
                DetailsValueName(label: 'Printed Price', childText: items!.printedPrice.toString()),
                DetailsValueName(label: 'MOQ', childText: items!.moq.toString()),
                DetailsValueName(
                  label: 'Added Date & Time',
                  childText: StaticValues.commonDateTimeFormat.format(items!.createdTime),
                ),
                if (items!.attributes.isNotEmpty)
                  DetailsValueName(
                    label: 'Attributes',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items!.attributes
                          .map(
                            (a) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${a.attributeKey}: ${a.attributeValue}${a.attributeUnit.isNotEmpty ? ' ${a.attributeUnit}' : ''}',
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                if (items!.otherImages.isNotEmpty)
                  DetailsValueName(
                    label: 'Other Images',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: items!.otherImages
                          .map(
                            (img) => ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          child: CachedImage(url: img.imageUrl, height: 80, width: 80),
                        ),
                      )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      bottomButtons: itemsStatus == Status.success
          ? [
        ViewDetailsButtonModel.closeButton(),
        ViewDetailsButtonModel.deleteButton(() async {
          bool deleted = await _deleteItems([items!]);
          if (deleted) AppNavigator.pop();
        }),
        ViewDetailsButtonModel.editButton(() {
          AppNavigator.pop();
          AppNavigator.navigate(
            AppRoutes.itemsEdit(data: AddEditItemScreens(itemCode: widget.itemCode)),
          );
        }),
      ]
          : [],
    );
  }

  Future<void> _getItems() async {
    itemsStatus = Status.loading;
    error = null;
    items = null;
    _refresh();

    final response = await ItemService.getItem(itemCode: widget.itemCode);

    if (!response.responseType.success || response.data == null) {
      error = response.firstError();
      itemsStatus = Status.error;
      _refresh();
      return;
    }

    items = response.data;
    itemsStatus = Status.success;
    _refresh();
  }

  void _refresh() => mounted ? setState(() {}) : null;
}
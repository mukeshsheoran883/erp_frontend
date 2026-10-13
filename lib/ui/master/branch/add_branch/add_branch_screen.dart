import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/network/api_manager_models.dart';
import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/custom_progress_indicator.dart';
import 'package:invently/assortment/widgets/error_loading_and_empty_widgets/error_retry_button.dart';
import 'package:invently/models/branch/branch_model.dart';
import 'package:invently/models/common/common_id_value_model.dart';
import 'package:invently/models/common/country_codes.dart';
import 'package:invently/network/branch_service.dart';
import 'package:invently/ui/master/branch/add_branch/add_branch_variables.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/validation/validator.dart';
import 'package:invently/utils/validation/validators.dart';
import 'package:invently/widgets/alert_dialog/double_button_alert.dart';
import 'package:invently/widgets/app_snack_bar.dart';
import 'package:invently/widgets/custom_drop_down.dart';
import 'package:invently/widgets/form_widgets/country_drop_down.dart';
import 'package:invently/widgets/form_widgets/phone_number_field.dart';
import 'package:invently/widgets/form_widgets/state_drop_down.dart';
import 'package:invently/widgets/page_widgets/create_edit_buttons.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/text_widget/text_field.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

part 'widget/add_branch_functions.dart';
part 'widget/branch_details_form.dart';

class AddEditBranchScreen extends StatefulWidget {
  final String? shopCode;

  const AddEditBranchScreen({
    super.key,
    required this.shopCode,
  });

  @override
  State<AddEditBranchScreen> createState() => _AddEditBranchScreenState();
}

class _AddEditBranchScreenState extends State<AddEditBranchScreen> {
  TabController? tabController;

  AddBranchParams params = AddBranchParams();

  @override
  void initState() {
    _getBranch(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppNavigator.setBreadCrumbs([
        AppRoutes.master,
        AppRoutes.branch,
        if (widget.shopCode == null)
          AppRoutes.branchAdd
        else
          AppRoutes.branchEdit(data: AddEditBranchScreen(shopCode: widget.shopCode)),
      ]);
    });
    super.initState();
  }

  @override
  void dispose() {
    _dispose(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBodyContainer(
      child: Center(
        child: params.branch.status == Status.loading
            ? const CustomProgressIndicator()
            : params.branch.status == Status.success
                ? Column(
                    children: [
                      Expanded(
                        child: _BranchDetailsForm(state: this),
                      ),
                      CreateEditButtons(
                        onCancelTap: () => _onCloseTap(this),
                        onSaveTap: () => _onSaveTap(this),
                        isEdit: true,
                      ),
                    ],
                  )
                : ErrorWidgetWithButton(onPressed: () => _getBranch(this), error: params.branch.error.errorMessage),
      ),
    );
  }

  void _refresh() => mounted ? setState(() {}) : null;
}

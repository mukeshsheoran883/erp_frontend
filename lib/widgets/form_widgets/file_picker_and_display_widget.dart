
import 'package:invently/assortment/future_handler/handle_future_with_alert.dart';
import 'package:invently/assortment/status.dart';
import 'package:invently/assortment/utils/file_utils.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/custom_image_model.dart';
import 'package:invently/utils/static_values.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/alert_dialog/show_notification_alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'file_pick_button.dart';

class FilePickerAndDisplayWidget extends StatelessWidget {
  final CustomImageModel? file;
  final Function()? onRemoveTap;
  final Function()? onHoverTap;
  final Function(CustomImageModel)? onTap;
  final Function(CustomImageModel)? onFileSelected;
  final FileType fileType;
  final String? title;
  final String? fileSizeText;
  final String label;
  final String? error;
  final bool required;
  final FileSize maxFileSize;
  final FileSize minFileSize;
  final double width;
  final double height;
  final EdgeInsets errorPadding;
  final BorderRadius? radius;

  const FilePickerAndDisplayWidget({
    super.key,
    required this.file,
    this.required = false,
    this.onRemoveTap,
    this.onHoverTap,
    this.onTap,
    this.onFileSelected,
    this.title,
    this.fileSizeText = '3 MB max file size',
    this.label = 'Upload Image',
    this.error,
    this.maxFileSize = const FileSize(size: 3, unit: FileSizeUnit.mb),
    this.minFileSize = const FileSize(size: 10, unit: FileSizeUnit.kb),
    this.fileType = FileType.any,
    this.width = 264.5,
    this.height = 264.5,
    this.errorPadding = const EdgeInsets.only(bottom: 8),
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: error != null ? 0 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text.rich(
                TextSpan(
                  text: title,
                  style: Ts.rgRegular(color: Tm.color(Tc.ipfTitle)),
                  children: required ? [TextSpan(text: ' *', style: Ts.lgRegular(color: Tm.color(Tc.redDef)))] : null,
                ),
              ),
            ),
          PickFileButton(
            onTap: file == null ? () => _openFilePicker(context) : null,
            label: file?.name ?? label,
            onHover: onHoverTap,
            onRemoveTap: file == null ? null : onRemoveTap,
            fileSizeText: fileSizeText,
            width: width,
            height: height,
            icon: fileType == FileType.image ? Assets.icons.imagePlaceholder : Assets.icons.fileUpload,
            file: file,
          ),
          if (error != null)
            Padding(
              padding: errorPadding,
              child: Text(error!, style: Ts.rgSemiRegular(color: Tm.color(Tc.redDef))),
            ),
        ],
      ),
    );
  }

  Future<void> _openFilePicker(BuildContext context) async {
    PlatformFile? selectedFile;
    CustomImageModel? customImageModel;
    await handleFutureWithAlert(
      errorMessage: () => StaticValues.commonErrorMessage,
      function: () async {
        final FilePickerResult? files = await FilePicker.platform.pickFiles(dialogTitle: title, type: fileType);

        if (files == null || files.files.isEmpty) return Status.none;

        selectedFile = files.files.first;

        /// Size validation
        String? errorMessage;

        final FileSize selectedFileSize = FileSize(size: selectedFile!.size.toDouble(), unit: FileSizeUnit.bytes);

        if (selectedFileSize.toBytes() > maxFileSize.toBytes()) {
          errorMessage =
          'Maximum size of selected file should be ${maxFileSize.getHumanReadableForm(inUnit: maxFileSize.unit)}, the selected file size is ${selectedFileSize.getHumanReadableForm(inUnit: maxFileSize.unit)}';
        } else if (selectedFile!.size < minFileSize.toBytes()) {
          errorMessage =
          'Minimum size of selected file should be ${minFileSize.getHumanReadableForm(inUnit: minFileSize.unit)}, the selected file size is ${selectedFileSize.getHumanReadableForm(inUnit: minFileSize.unit)}';
        }
        if (context.mounted && errorMessage != null) {
          await showSingleButtonAlert(title: 'Error', text: errorMessage);
        }

        /// stop function if there was a validation error
        if (errorMessage != null) return Status.none;

        customImageModel = CustomImageModel.fromPlatFormFile(selectedFile!, true);

        customImageModel!.bytes = await selectedFile!.xFile.readAsBytes();

        return Status.success;
      },
      onSuccess: () => onFileSelected?.call(customImageModel!),
    );
  }
}

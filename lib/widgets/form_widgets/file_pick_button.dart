
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/image_with_shimmer.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/models/common/custom_image_model.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:invently/widgets/broken_image_widget.dart';
import 'package:flutter/material.dart';

class PickFileButton extends StatelessWidget {
  final Function()? onTap;
  final Function()? onHover;
  final Function()? onRemoveTap;
  final String? label;
  final String? fileSizeText;
  final double width;
  final double height;
  final String icon;
  final CustomImageModel? file;

  const PickFileButton({
    super.key,
    required this.onTap,
    required this.width,
    required this.height,
    required this.icon,
    this.onHover,
    this.onRemoveTap,
    this.label,
    this.fileSizeText,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: HoverGD(
            onTap: onTap,
            onHover: onHover,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Container(
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: Tm.color(Tc.ipfDef), borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: _canFileBeDisplayed()
                  ? _ImageDisplayWidget(file: file!)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgImage(icon, height: 24, width: 24, color: Tm.color(Tc.txtH3)),
                        if (label != null)
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text(label!, style: Ts.rgMedium(color: Tm.color(Tc.txtH2))),
                          ),
                        if (fileSizeText != null && file == null)
                          Text(fileSizeText!, style: Ts.rgRegular(color: Tm.color(Tc.ipfTitle))),
                      ],
                    ),
            ),
          ),
        ),
        if (onRemoveTap != null)
          HoverGD(
            onTap: onRemoveTap,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(right: 4, bottom: 3),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                color: Tm.color(Tc.redDefLight),
              ),
              child: SvgImage(Assets.icons.trash, width: 22, height: 22, color: Tm.color(Tc.redDef)),
            ),
          ),
      ],
    );
  }

  bool _canFileBeDisplayed() {
    if (file == null) return false;
    if (!file!.isLocalImage) return true;
    if (file?.bytes == null) return false;
    if (file!.isLocalImage && file!.bytes!.isNotEmpty) return true;

    return false;
  }
}

class _ImageDisplayWidget extends StatelessWidget {
  final CustomImageModel file;

  const _ImageDisplayWidget({required this.file});

  @override
  Widget build(BuildContext context) {
    return file.isLocalImage
        ? Image.memory(
            file.bytes!,
            fit: BoxFit.cover,
            errorBuilder: (cont, o, s) {
              return const BrokenImageWidget();
            },
          )
        : ImageWithShimmer(url: file.path);
  }
}

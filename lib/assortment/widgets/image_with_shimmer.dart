import 'package:invently/widgets/broken_image_widget.dart';
import 'package:flutter/material.dart';

import 'cached_image.dart';

class ImageWithShimmer extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BorderRadius radius;
  final BoxShape? shape;
  final Color? borderColor;
  final Map<String, dynamic>? headers;

  const ImageWithShimmer({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = BorderRadius.zero,
    this.shape,
    this.headers,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return _AspectRatio(
      height: height,
      width: width,
      key: key,
      child: Container(
        width: width,
        height: height,
        decoration: decoration(),
        child: (url == null || url!.isEmpty)
            ? const Padding(padding: EdgeInsets.all(12), child: BrokenImageWidget())
            : ClipRRect(
                borderRadius: shape == BoxShape.circle ? const BorderRadius.all(Radius.circular(1000 * 1000)) : radius,
                child: CachedImage(
                  url: url!,
                  headers: headers,
                  key: Key(url!),
                  height: height,
                  width: width,
                  radius: radius,
                  shape: shape,
                ),
              ),
      ),
    );
  }

  BoxDecoration decoration() => shape != null
      ? BoxDecoration(
          shape: shape!,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        )
      : BoxDecoration(
          borderRadius: radius,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        );
}

class _AspectRatio extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  const _AspectRatio({super.key, required this.width, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ((height != null && height! > 0) && (width != null && width! > 0))
        ? AspectRatio(aspectRatio: width! / height!, child: child)
        : child;
  }
}

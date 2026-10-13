import 'package:invently/utils/static_values.dart';
import 'package:invently/widgets/broken_image_widget.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import 'error_loading_and_empty_widgets/shimmer.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BorderRadius radius;
  final BoxShape? shape;
  final Map<String, dynamic>? headers;
  final Widget? errorWidget;
  const CachedImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.headers,
    this.radius = BorderRadius.zero,
    this.shape = BoxShape.rectangle,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: FastCachedImage(
        url: url,
        headers: headers ?? StaticValues.defaultHeaders(),
        fit: BoxFit.cover,
        height: height,
        width: width,
        showErrorLog: false,
        loadingBuilder: (context, a) => ShimmerWidget(
          radius: radius,
          shape: shape,
          height: height,
          width: width,
        ),
        errorBuilder: (context, a, e) => errorWidget != null
            ? FittedBox(child: errorWidget)
            : SizedBox(
                height: height,
                width: width,
                child: const Padding(padding: EdgeInsets.all(12), child: BrokenImageWidget()),
              ),
      ),
    );
  }
}

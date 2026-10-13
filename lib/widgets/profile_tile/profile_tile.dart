
import 'package:invently/assortment/extensions/string_extensions.dart';
import 'package:invently/assortment/widgets/button/hover_gesture_detector.dart';
import 'package:invently/assortment/widgets/cached_image.dart';
import 'package:invently/assortment/widgets/svg_image.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/provider/authentication_provider.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/utils/theme/text_style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class ProfileTile extends StatefulWidget {
  const ProfileTile({super.key});

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        height: 68,
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Tm.color(Tc.menuItemBgFill),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
        ),
        child: Consumer<AuthenticationProvider>(
          builder: (context, provider, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedImage(
                  url: provider.getUserDetails().profilePhotoUrl,
                  width: 48,
                  height: 48,
                  errorWidget: SvgImage(Assets.icons.person, height: 48, width: 48, color: Tm.color(Tc.txtH4)),
                  radius: const BorderRadius.all(Radius.circular(8)),
                ),
                const SizedBox(width: 14),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              provider.getUserDetails().name.toPascalCase(),
                              overflow: TextOverflow.ellipsis,
                              style: Ts.rgMedium(color: Tm.color(Tc.txtH1)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          HoverGD(
                            onTap: _onFullScreenTap,
                            hoverColor: Colors.transparent,
                            clickColor: Colors.transparent,
                            child: Container(
                              alignment: Alignment.center,
                              color: Tm.color(Tc.comCardBg),
                              child: SvgImage(
                                Assets.icons.fullscreen,
                                width: 14,
                                height: 14,
                                color: Tm.color(Tc.ipfTitle),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgImage(Assets.icons.branch, width: 20, height: 20, color: Tm.color(Tc.txtH4)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              provider.getUserDetails().defaultShop.value.toPascalCase(),
                              overflow: TextOverflow.ellipsis,
                              style: Ts.mdRegular(color: Tm.color(Tc.txtH3)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onFullScreenTap() {
    html.document.fullscreenElement == null
        ? html.document.documentElement?.requestFullscreen()
        : html.document.exitFullscreen();
    if (mounted) setState(() {});
  }
}

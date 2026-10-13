
import 'package:invently/utils/globals.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class PageShelf extends StatelessWidget {
  final List<Widget> children;

  const PageShelf({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(20), child: Row(children: children));
  }
}


class ReportsDetailsHeader extends StatelessWidget {
  final List<ReportsDetailsHeaderModel> children;
  final bool logBalance;

  const ReportsDetailsHeader({super.key, required this.children, this.logBalance = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, constrains) {
          if (logBalance) {
            Globals.logger.log(
              'Remaining %: ${100 - (children.map((e) => e.percentWidth).reduce((a, e) => a + e))}',
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < children.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border:  Border(
                          right: BorderSide(
                            color: (i != children.length - 1)
                                ? Tm.color(Tc.tableDivider)
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      width: (constrains.maxWidth * children[i].percentWidth) / 100,
                      child: children[i].child,
                    ),
                    // if (i != children.length - 1) Container(color: Colors.red,width: 2,height: 5,),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class ReportsDetailsHeaderModel {
  Widget child;
  double percentWidth;

  ReportsDetailsHeaderModel({required this.child, required this.percentWidth});
}
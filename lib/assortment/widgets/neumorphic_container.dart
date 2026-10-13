
import 'package:gusto_neumorphic/gusto_neumorphic.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final NeumorphicShape shape;
  final NeumorphicBoxShape boxShape;
  final NeumorphicBorder border;
  final LightSource lightSource;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.color,
    this.shape = NeumorphicShape.flat,
    this.border = const NeumorphicBorder.none(),
    this.boxShape = const NeumorphicBoxShape.rect(),
    this.lightSource = LightSource.topLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        color: color,
        shape: shape,
        boxShape: boxShape,
        border: border,
        lightSource: lightSource,
      ),
      child: child,
    );
  }
}

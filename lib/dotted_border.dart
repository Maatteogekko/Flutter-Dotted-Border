library dotted_border;

import 'package:dotted_border/dash_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'dash_painter.dart';

/// Add a dotted border around any [child] widget. The [strokeWidth] property
/// defines the width of the dashed border and [color] determines the stroke
/// paint color. [CircularIntervalList] is populated with the [dashPattern] to
/// render the appropriate pattern. The [radius] property is taken into account
/// only if the [borderType] is [BorderType.rRect]. A [customPath] can be passed in
/// as a parameter if you want to draw a custom shaped border.
///
/// [childOnTop] specifies wether the [child] should be placed over or under the border. Default is `true`.
///
/// An [animation] can be used to animate the position of the path along its length. A repeated animation from 0 to 1 gives the effect of a continuously rotating border.
class DottedBorder extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets borderPadding;
  final double strokeWidth;
  final Color color;
  final Gradient? gradient;
  final List<double> dashPattern;
  final BorderType borderType;
  final Radius radius;
  final StrokeCap strokeCap;
  final PathBuilder? customPath;
  final StackFit stackFit;
  final Animation<double>? animation;
  final bool childOnTop;

  DottedBorder({
    Key? key,
    required this.child,
    this.color = Colors.black,
    this.gradient,
    this.strokeWidth = 1,
    this.borderType = BorderType.rect,
    this.dashPattern = const <double>[3, 1],
    this.padding = const EdgeInsets.all(2),
    this.borderPadding = EdgeInsets.zero,
    this.radius = Radius.zero,
    this.strokeCap = StrokeCap.butt,
    this.customPath,
    this.stackFit = StackFit.loose,
    this.animation,
    this.childOnTop = true,
  })  : assert(_isValidDashPattern(dashPattern), 'Invalid dash pattern'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final stackChild = Padding(
      padding: padding,
      child: child,
    );

    return Stack(
      fit: stackFit,
      children: <Widget>[
        if (!childOnTop) stackChild,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: DashedPainter(
                padding: borderPadding,
                strokeWidth: strokeWidth,
                radius: radius,
                color: color,
                gradient: gradient,
                borderType: borderType,
                dashPattern: dashPattern,
                customPath: customPath,
                strokeCap: strokeCap,
                animation: animation,
              ),
            ),
          ),
        ),
        if (childOnTop) stackChild,
      ],
    );
  }

  /// Compute if [dashPattern] is valid. The following conditions need to be met
  /// * Cannot be null or empty
  /// * If [dashPattern] has only 1 element, it cannot be 0
  static bool _isValidDashPattern(List<double>? dashPattern) {
    final Set<double>? dashSet = dashPattern?.toSet();
    if (dashSet == null) return false;
    if (dashSet.length == 1 && dashSet.elementAt(0) == 0.0) return false;
    if (dashSet.isEmpty) return false;
    return true;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(DiagnosticsProperty<EdgeInsets>('borderPadding', borderPadding));
    properties.add(DoubleProperty('strokeWidth', strokeWidth));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<Gradient?>('gradient', gradient));
    properties.add(IterableProperty<double>('dashPattern', dashPattern));
    properties.add(EnumProperty<BorderType>('borderType', borderType));
    properties.add(DiagnosticsProperty<Radius>('radius', radius));
    properties.add(EnumProperty<StrokeCap>('strokeCap', strokeCap));
    properties.add(ObjectFlagProperty<PathBuilder?>.has('customPath', customPath));
    properties.add(EnumProperty<StackFit>('stackFit', stackFit));
    properties.add(DiagnosticsProperty<Animation<double>?>('animation', animation));
    properties.add(DiagnosticsProperty<bool>('childOnTop', childOnTop));
  }
}

/// The different supported BorderTypes
enum BorderType { circle, rRect, rect, oval }

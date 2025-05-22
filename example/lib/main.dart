import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool animate = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dotted Border'),
          actions: [
            Switch(
              value: animate,
              activeTrackColor: Colors.white,
              activeColor: Colors.blue.shade200,
              onChanged: (value) => setState(() {
                animate = value;
              }),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Examples(animate: animate),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('animate', animate));
  }
}

class Examples extends StatefulWidget {
  const Examples({
    Key? key,
    required this.animate,
  }) : super(key: key);

  final bool animate;

  @override
  State<Examples> createState() => _ExamplesState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('animate', animate));
  }
}

class _ExamplesState extends State<Examples> with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) controller.repeat();
  }

  @override
  void didUpdateWidget(covariant Examples oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate && !widget.animate) controller.stop();
    if (!oldWidget.animate && widget.animate) controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: <Widget>[
        rectBorderWidget,
        rectBorderWithPaddingWidget,
        roundedRectBorderWidget,
        customBorder,
        roundStrokeCap,
        solidBorder,
        fullWidthPath,
      ],
    );
  }

  /// Draw a border with rectangular border
  Widget get rectBorderWidget {
    return DottedBorder(
      animation: controller,
      dashPattern: const [8, 4],
      strokeWidth: 2,
      child: Container(
        height: 200,
        width: 120,
        color: Colors.red,
      ),
    );
  }

  /// Use [DottedBorder.borderPadding] to prevent the border from being drawn outside the widget.
  Widget get rectBorderWithPaddingWidget {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: DottedBorder(
        animation: controller,
        dashPattern: const [8, 4],
        strokeWidth: 8,
        padding: const EdgeInsets.all(8),
        borderPadding: const EdgeInsets.all(4),
        child: Container(
          height: 200,
          width: 120,
          // ignore: deprecated_member_use
          color: Colors.red.withOpacity(0.5),
        ),
      ),
    );
  }

  /// Draw a border with a rounded rectangular border
  Widget get roundedRectBorderWidget {
    return DottedBorder(
      animation: controller,
      borderType: BorderType.rRect,
      radius: const Radius.circular(12),
      // padding: EdgeInsets.all(6),
      borderPadding: const EdgeInsets.all(3),
      dashPattern: const [20, 4],
      strokeWidth: 2,
      childOnTop: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 200,
          width: 120,
          color: Colors.amber,
        ),
      ),
    );
  }

  /// Draw a border with custom path border
  Widget get customBorder {
    final Path customPath = Path()
      ..moveTo(20, 20)
      ..lineTo(50, 100)
      ..lineTo(20, 200)
      ..lineTo(100, 100)
      ..lineTo(20, 20);

    return DottedBorder(
      animation: controller,
      customPath: (_) => customPath,
      color: Colors.indigo,
      dashPattern: const [8, 4],
      strokeWidth: 2,
      child: Container(
        height: 220,
        width: 120,
        color: Colors.green.withAlpha(20),
      ),
    );
  }

  /// Set border stroke cap
  Widget get roundStrokeCap {
    return DottedBorder(
      animation: controller,
      dashPattern: const [8, 4],
      strokeWidth: 2,
      strokeCap: StrokeCap.round,
      borderType: BorderType.rRect,
      radius: const Radius.circular(5),
      child: Container(
        height: 200,
        width: 120,
        color: Colors.red,
      ),
    );
  }

  Widget get solidBorder {
    return DottedBorder(
      animation: controller,
      dashPattern: const [4, 3],
      strokeWidth: 2,
      strokeCap: StrokeCap.round,
      child: Container(
        color: Colors.green,
        height: 200,
        width: 120,
      ),
    );
  }

  Widget get fullWidthPath {
    return DottedBorder(
      animation: controller,
      customPath: (size) {
        return Path()
          ..moveTo(0, 20)
          ..lineTo(size.width, 20);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimationController>('controller', controller));
  }
}

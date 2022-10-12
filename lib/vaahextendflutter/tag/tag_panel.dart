import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../env.dart';
import '../helpers/constants.dart';
import '../helpers/styles.dart';

const double constHandleWidth = 22.0;
const double constHandleHeight = 106.0;

typedef TagPanelBuilder = Widget Function(
  BuildContext context,
  EdgeInsets padding,
);

@immutable
class TagPanelHost extends StatefulWidget {
  const TagPanelHost({
    Key? key,
    required this.navigatorKey,
    required this.child,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  TagPanelHostState createState() => TagPanelHostState();

  static TagPanelHostState of(BuildContext context) {
    return context.findAncestorStateOfType<TagPanelHostState>()!;
  }
}

class TagPanelHostState extends State<TagPanelHost>
    with SingleTickerProviderStateMixin {
  final _drawerKey = GlobalKey();
  final _focusScopeNode = FocusScopeNode();
  final _handleWidth = constHandleWidth;

  late AnimationController _controller;
  EnvController? envController;
  bool showEnvAndVersionTag = false;

  @override
  void initState() {
    super.initState();
    bool envControllerExists = Get.isRegistered<EnvController>();
    if (envControllerExists) {
      envController = Get.find<EnvController>();
      showEnvAndVersionTag =
          envController?.config.showEnvAndVersionTag ?? false;
    }
    _controller = AnimationController(
      duration: duration250milli,
      vsync: this,
    );
    _controller.addStatusListener(
      (AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          _focusScopeNode.unfocus();
        }
      },
    );
  }

  NavigatorState get navigator => widget.navigatorKey.currentState!;

  void open() => _controller.fling(velocity: 1.0);

  void close() => _controller.fling(velocity: -1.0);

  void toggle() {
    if (_controller.value > 0.5) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return showEnvAndVersionTag
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final width = constraints.maxWidth;
              final minFactor = (_handleWidth / width);
              return Stack(
                fit: StackFit.expand,
                children: [
                  widget.child,
                  GestureDetector(
                    onHorizontalDragDown: (DragDownDetails details) {
                      _controller.stop();
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                      _controller.value += (-details.primaryDelta! / width);
                    },
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (_controller.isDismissed) {
                        return;
                      }
                      if (details.primaryVelocity!.abs() >= 365.0) {
                        final visualVelocity =
                            -details.primaryVelocity! / width;
                        _controller.fling(velocity: visualVelocity);
                      } else if (_controller.value < 0.5) {
                        close();
                      } else {
                        open();
                      }
                    },
                    onHorizontalDragCancel: () {
                      if (_controller.isDismissed || _controller.isAnimating) {
                        return;
                      }
                      if (_controller.value < 0.5) {
                        close();
                      } else {
                        open();
                      }
                    },
                    excludeFromSemantics: true,
                    child: RepaintBoundary(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget? child) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: _controller.value + minFactor,
                              child: child,
                            );
                          },
                          child: RepaintBoundary(
                            child: FocusScope(
                              key: _drawerKey,
                              node: _focusScopeNode,
                              child: _EnvPanel(
                                handleWidth: _handleWidth,
                                onHandlePressed: toggle,
                                config: envController!.config,
                                child: Builder(
                                  builder: (BuildContext context) {
                                    return ListView(
                                      primary: false,
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).padding.top +
                                                kDeafaultPadding,
                                        bottom: kDeafaultPadding,
                                        left: _handleWidth + kDeafaultPadding,
                                        right: kDeafaultPadding,
                                      ),
                                      children: [
                                        SelectableText(
                                          envController!.config.envType,
                                          style: TextStyles.regular6,
                                        ),
                                        verticalMargin4,
                                        SelectableText(
                                          'Version: ${envController!.config.version}',
                                          style: TextStyles.regular6,
                                        ),
                                        verticalMargin4,
                                        SelectableText(
                                          'Build: ${envController!.config.build}',
                                          style: TextStyles.regular6,
                                        ),
                                        verticalMargin16,
                                        SelectableText(
                                          'Base URL: ${envController!.config.baseUrl}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin8,
                                        SelectableText(
                                          'API Base URL: ${envController!.config.apiBaseUrl}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin8,
                                        SelectableText(
                                          'Analytics Id: ${envController!.config.analyticsId}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin8,
                                        SelectableText(
                                          'Console Logs Enabled: ${envController!.config.enableConsoleLogs}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin8,
                                        SelectableText(
                                          'Local Logs Enabled: ${envController!.config.enableLocalLogs}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin8,
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        : widget.child;
  }
}

@immutable
class _EnvPanel extends StatelessWidget {
  const _EnvPanel({
    Key? key,
    required this.handleWidth,
    required this.onHandlePressed,
    required this.config,
    required this.child,
  }) : super(key: key);

  final double handleWidth;
  final VoidCallback onHandlePressed;
  final EnvironmentConfig config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: config.envAndVersionTagColor,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: config.envAndVersionTagColor,
          brightness: Brightness.dark,
        ),
      ),
      child: Material(
        color: config.envAndVersionTagColor,
        clipBehavior: Clip.antiAlias,
        shape: const _PanelBorder(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    maintainState: true,
                    builder: (BuildContext context) => child,
                  ),
                ],
              ),
            ),
            RepaintBoundary(
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkResponse(
                  onTap: onHandlePressed,
                  radius: constHandleHeight / 1.25,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SizedBox(
                      width: constHandleHeight,
                      height: handleWidth,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 4,
                            bottom: 4,
                            left: 4,
                          ),
                          child: Text(
                            '${config.envType} ${config.version}',
                            style: TextStyles.regular8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelBorder extends ShapeBorder {
  const _PanelBorder();

  static const double handleWidth = constHandleWidth + 4;
  static const double handleHeight = constHandleHeight;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => const _PanelBorder();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const borderRadius = BorderRadius.all(Radius.circular(handleWidth / 2));
    final height = ((rect.height - handleHeight) / 2);
    final top = rect.top + height;
    final bottom = rect.bottom - height;
    return Path.combine(
      PathOperation.union,
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()
          ..addRRect(borderRadius.toRRect(
            Rect.fromLTRB(
              -handleWidth,
              -handleWidth,
              handleWidth - 4.0,
              top,
            ),
          ))
          ..addRRect(borderRadius.toRRect(
            Rect.fromLTRB(
              -handleWidth,
              bottom,
              handleWidth - 4.0,
              rect.bottom + handleWidth,
            ),
          ))
          ..addRect(Rect.fromLTWH(0, top, handleWidth / 2, handleHeight)),
      ),
      Path()
        ..addRRect(
          borderRadius
              .toRRect(Rect.fromLTWH(0, top, handleWidth, handleHeight)),
        ),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    //
  }
}

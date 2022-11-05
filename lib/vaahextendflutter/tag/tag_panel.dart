// *****************************************
// Dev helper panel that comes from bottom
// example: https://img-v4.getdemo.dev/screenshot/qemu-system-x86_64_9g9eFWHZK5.mp4

// If you change any code in this file you'll probably have to restart the app
// HotReload won't work because most of the variables are constants and are
// assigned with some values when material app is build.
// *****************************************

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../env.dart';
import '../helpers/constants.dart';
import '../helpers/styles.dart';

const double constHandleWidth = 180.0; // tag handle width
const double constHandleHeight = 28.0; // tag handle height

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
  final _handleHeight = constHandleHeight;
  late AnimationController _controller;

  // To determine whether to show tag or not deending on env variable
  EnvController? envController;
  bool showEnvAndVersionTag = false;

  @override
  void initState() {
    super.initState();
    // check if envController Exists in app or not
    bool envControllerExists = Get.isRegistered<EnvController>();
    if (envControllerExists) {
      // get env controller and set variable showEnvAndVersionTag
      envController = Get.find<EnvController>();
      showEnvAndVersionTag =
          envController?.config.showEnvAndVersionTag ?? false;
    }
    // initialise AnimationController
    _controller = AnimationController(
      duration: duration250milli,
      vsync: this,
    );
    // addStatusListener to focus and unfocus the panel shown
    _controller.addStatusListener(
      (AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          _focusScopeNode.unfocus();
        }
      },
    );
  }

  NavigatorState get navigator => widget.navigatorKey.currentState!;

  // will open panel
  void open() => _controller.fling(velocity: 1.0);

  // will close panel
  void close() => _controller.fling(velocity: -1.0);

  // will open/ close panel based on if panel is half open or close
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
              final height = constraints.maxHeight;
              final minFactor = (_handleHeight / height);
              return Stack(
                fit: StackFit.expand,
                children: [
                  widget.child,
                  GestureDetector(
                    onVerticalDragDown: (DragDownDetails details) {
                      _controller.stop();
                    },
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      _controller.value += (-details.primaryDelta! / height);
                    },
                    onVerticalDragEnd: (DragEndDetails details) {
                      if (_controller.isDismissed) {
                        return;
                      }
                      if (details.primaryVelocity!.abs() >= 365.0) {
                        final visualVelocity =
                            -details.primaryVelocity! / height;
                        _controller.fling(velocity: visualVelocity);
                      } else if (_controller.value < 0.5) {
                        close();
                      } else {
                        open();
                      }
                    },
                    onVerticalDragCancel: () {
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
                        alignment: Alignment.bottomCenter,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget? child) {
                            return Align(
                              alignment: Alignment.topCenter,
                              heightFactor: _controller.value + minFactor,
                              child: child,
                            );
                          },
                          child: RepaintBoundary(
                            child: FocusScope(
                              key: _drawerKey,
                              node: _focusScopeNode,
                              child: _EnvPanel(
                                handleHeight: _handleHeight,
                                onHandlePressed: toggle,
                                config: envController!.config,
                                child: Builder(
                                  builder: (BuildContext context) {
                                    return ListView(
                                      primary: false,
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).padding.top +
                                                defaultPadding +
                                                _handleHeight,
                                        bottom: defaultPadding,
                                        left: defaultPadding,
                                        right: defaultPadding,
                                      ),
                                      children: [
                                        SelectableText(
                                          envController!.config.envType,
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin4,
                                        SelectableText(
                                          'Version: ${envController!.config.version}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin4,
                                        SelectableText(
                                          'Build: ${envController!.config.build}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin16,
                                        SelectableText(
                                          'Backend URL: ${envController!.config.backendUrl}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin8,
                                        SelectableText(
                                          'API URL: ${envController!.config.apiUrl}',
                                          style: TextStyles.regular3,
                                        ),
                                        verticalMargin8,
                                        SelectableText(
                                          'Firebase Id: ${envController!.config.firebaseId}',
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
    required this.handleHeight,
    required this.onHandlePressed,
    required this.config,
    required this.child,
  }) : super(key: key);

  final double handleHeight;
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
                alignment: Alignment.topCenter,
                child: InkResponse(
                  onTap: onHandlePressed,
                  radius: constHandleWidth / 1.25,
                  child: RotatedBox(
                    quarterTurns: 0,
                    child: SizedBox(
                      width: constHandleWidth,
                      height: handleHeight,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          child: Text(
                            '${config.envType} ${config.version}+${config.build}',
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

  static const double handleWidth = constHandleWidth;
  static const double handleHeight = constHandleHeight +
      4; // if you want a small width line visible with tag remove + 4

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
    const borderRadius = BorderRadius.all(Radius.circular(handleHeight / 2));

    final width = ((rect.width - handleWidth) / 2);
    final leftend = rect.left + width;
    final rightend = rect.right - width;
    return Path.combine(
      PathOperation.union,
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRect(
            rect,
          ),
        Path()
          ..addRRect(
            borderRadius.toRRect(
              Rect.fromLTRB(
                rect.left - handleWidth,
                -handleHeight,
                leftend,
                handleHeight - 4.0,
              ),
            ),
          )
          ..addRRect(
            borderRadius.toRRect(
              Rect.fromLTRB(
                rightend,
                -handleHeight,
                rect.right + handleHeight,
                handleHeight - 4.0,
              ),
            ),
          )
          ..addRect(
            Rect.fromLTWH(
              leftend,
              0,
              handleWidth,
              handleHeight / 2,
            ),
          ),
      ),
      Path()
        ..addRRect(
          borderRadius.toRRect(
            Rect.fromLTWH(
              leftend,
              0,
              handleWidth,
              handleHeight,
            ),
          ),
        ),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    //
  }
}

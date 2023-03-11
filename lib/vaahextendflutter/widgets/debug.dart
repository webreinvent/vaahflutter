// *****************************************
// Dev helper panel that comes from bottom
// example: https://img-v4.getdemo.dev/screenshot/qemu-system-x86_64_9g9eFWHZK5.mp4

// If you change any code in this file you'll probably have to restart the app
// HotReload won't work because most of the variables are constants and are
// assigned with some values when material app is build.
// *****************************************

import 'package:flutter/material.dart';

import '../env.dart';
import '../helpers/constants.dart';
import '../helpers/styles.dart';

const double constHandleWidth = 180.0; // tag handle width
const double constHandleHeight = 38.0; // tag handle height

@immutable
class DebugWidget extends StatefulWidget {
  const DebugWidget({
    Key? key,
    required this.navigatorKey,
    required this.child,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  DebugWidgetState createState() => DebugWidgetState();

  static DebugWidgetState of(BuildContext context) {
    return context.findAncestorStateOfType<DebugWidgetState>()!;
  }
}

class DebugWidgetState extends State<DebugWidget> with SingleTickerProviderStateMixin {
  final _drawerKey = GlobalKey();
  final _focusScopeNode = FocusScopeNode();
  final _handleHeight = constHandleHeight;
  late AnimationController _controller;

  // To determine whether to show tag or not depending on env variable
  late EnvironmentConfig _environmentConfig;
  bool showDebugPanel = false;

  @override
  void initState() {
    super.initState();
    // get env controller and set variable showDebugPanel
    _environmentConfig = EnvironmentConfig.getEnvConfig();
    showDebugPanel = _environmentConfig.showDebugPanel;
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
    return showDebugPanel
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
                        final visualVelocity = -details.primaryVelocity! / height;
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
                                config: _environmentConfig,
                                child: Builder(
                                  builder: (BuildContext context) {
                                    return ListView(
                                      primary: false,
                                      padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).padding.top +
                                            defaultPadding +
                                            _handleHeight,
                                        bottom: defaultPadding,
                                        left: defaultPadding,
                                        right: defaultPadding,
                                      ),
                                      children: [
                                        ..._showDetails(
                                          [
                                            'App Title: ${_environmentConfig.appTitle}',
                                            'App Title Short: ${_environmentConfig.appTitleShort}',
                                            _environmentConfig.envType,
                                            'Version: ${_environmentConfig.version}',
                                            'Build: ${_environmentConfig.build}',
                                          ],
                                        ),
                                        verticalMargin24,
                                        ..._showDetails(
                                          [
                                            'Backend URL: ${_environmentConfig.backendUrl}',
                                            'API URL: ${_environmentConfig.apiUrl}',
                                            'Request and Response Timeout: ${(_environmentConfig.timeoutLimit) / 1000} Seconds',
                                            'Firebase Id: ${_environmentConfig.firebaseId}',
                                            'Local Logs Enabled (Console + Device Specific): ${_environmentConfig.enableLocalLogs}',
                                            'Cloud Logs Enabled: ${_environmentConfig.enableCloudLogs}',
                                            if (null != _environmentConfig.sentryConfig) ...[
                                              'Sentry DSN: ${_environmentConfig.sentryConfig!.dsn}',
                                              'Sentry Auto App Start (Record Cold And Warm Start Time): ${_environmentConfig.sentryConfig!.autoAppStart}',
                                              'Sentry Traces Sample Rate: ${_environmentConfig.sentryConfig!.tracesSampleRate}',
                                              'Sentry User Interaction Tracing: ${_environmentConfig.sentryConfig!.enableUserInteractionTracing}',
                                              'Sentry Auto Performance Tracking: ${_environmentConfig.sentryConfig!.enableAutoPerformanceTracking}',
                                              'Sentry Assets Instrumentation: ${_environmentConfig.sentryConfig!.enableAssetsInstrumentation}',
                                            ],
                                            'API Logs Interceptor: ${_environmentConfig.enableApiLogInterceptor}',
                                          ],
                                        ),
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

  List<Widget> _showDetails(List<String> details) {
    return details
        .map(
          (detail) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                detail,
                style: TextStyles.regular3,
              ),
              verticalMargin8,
            ],
          ),
        )
        .toList(growable: false);
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
        primaryColor: config.debugPanelColor,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: config.debugPanelColor,
          brightness: Brightness.dark,
        ),
      ),
      child: Material(
        color: config.debugPanelColor,
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
                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
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
  static const double handleHeight =
      constHandleHeight + 4; // if you want a small width line visible with tag remove + 4

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
    final leftEnd = rect.left + width;
    final rightEnd = rect.right - width;
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
                leftEnd,
                handleHeight - 4.0,
              ),
            ),
          )
          ..addRRect(
            borderRadius.toRRect(
              Rect.fromLTRB(
                rightEnd,
                -handleHeight,
                rect.right + handleHeight,
                handleHeight - 4.0,
              ),
            ),
          )
          ..addRect(
            Rect.fromLTWH(
              leftEnd,
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
              leftEnd,
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

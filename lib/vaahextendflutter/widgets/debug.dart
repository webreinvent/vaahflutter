// *****************************************
// Dev helper panel that comes from bottom
// example: https://img-v4.getdemo.dev/screenshot/qemu-system-x86_64_9g9eFWHZK5.mp4

// If you change any code in this file you'll probably have to restart the app
// HotReload won't work because most of the variables are constants and are
// assigned with some values when material app is build.
// *****************************************

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme.dart';
import '../base/root_assets_controller.dart';
import '../env/env.dart';
import '../env/notification.dart';
import '../helpers/constants.dart';
import 'atoms/buttons.dart';
import 'atoms/input_text.dart';

const double constHandleWidth = 180.0; // tag handle width
const double constHandleHeight = 38.0; // tag handle height

@immutable
class DebugWidget extends StatefulWidget {
  const DebugWidget({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

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
    _environmentConfig = EnvironmentConfig.getConfig;
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
    final double topMargin = MediaQuery.of(context).padding.top + defaultMargin;
    return showDebugPanel
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final height = constraints.maxHeight - topMargin;
              final minFactor = (_handleHeight / height);
              return Stack(
                fit: StackFit.expand,
                children: [
                  widget.child,
                  Container(
                    margin: EdgeInsets.only(top: topMargin),
                    child: GestureDetector(
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
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top: _handleHeight,
                                        ),
                                        child: Container(
                                          margin: allPadding24,
                                          child: SingleChildScrollView(
                                            physics: const BouncingScrollPhysics(),
                                            child: Column(
                                              children: [
                                                _ShowDetails(
                                                  contentHolder: PanelDataContentHolder(
                                                    content: {
                                                      'App Title':
                                                          Data(value: _environmentConfig.appTitle),
                                                      'App Title Short': Data(
                                                        value: _environmentConfig.appTitleShort,
                                                      ),
                                                      'Environment': Data(
                                                        value: _environmentConfig.envType,
                                                      ),
                                                      'Version':
                                                          Data(value: _environmentConfig.version),
                                                      'Build':
                                                          Data(value: _environmentConfig.build),
                                                      'API URL':
                                                          Data(value: _environmentConfig.apiUrl),
                                                      'Request and Response Timeout': Data(
                                                        value:
                                                            '${_environmentConfig.timeoutLimit} Seconds',
                                                      ),
                                                      'API Logs Interceptor': Data(
                                                        value: _environmentConfig
                                                                .enableApiLogInterceptor
                                                            ? 'enabled'
                                                            : 'disabled',
                                                        color: _environmentConfig
                                                                .enableApiLogInterceptor
                                                            ? AppTheme.colors['success']
                                                            : AppTheme.colors['danger'],
                                                      ),
                                                      'Local Logs': Data(
                                                        value: _environmentConfig.enableLocalLogs
                                                            ? 'enabled'
                                                            : 'disabled',
                                                        color: _environmentConfig.enableLocalLogs
                                                            ? AppTheme.colors['success']
                                                            : AppTheme.colors['danger'],
                                                      ),
                                                      'Cloud Logs': Data(
                                                        value: _environmentConfig.enableCloudLogs
                                                            ? 'enabled'
                                                            : 'disabled',
                                                        color: _environmentConfig.enableCloudLogs
                                                            ? AppTheme.colors['success']
                                                            : AppTheme.colors['danger'],
                                                      ),
                                                      'CloudLoggingService': Data(
                                                        value: _environmentConfig
                                                            .cloudLoggingService.name,
                                                      ),
                                                      if (null !=
                                                          _environmentConfig.sentryConfig) ...{
                                                        'Sentry DSN': Data(
                                                          value:
                                                              _environmentConfig.sentryConfig!.dsn,
                                                        ),
                                                        'Sentry Traces Sample Rate': Data(
                                                          value: _environmentConfig
                                                              .sentryConfig!.tracesSampleRate
                                                              .toString(),
                                                        ),
                                                        'Sentry Auto App Start (Record Cold And Warm Start Time)':
                                                            Data(
                                                          value: _environmentConfig
                                                                  .sentryConfig!.autoAppStart
                                                              ? 'enabled'
                                                              : 'disabled',
                                                          color: _environmentConfig
                                                                  .sentryConfig!.autoAppStart
                                                              ? AppTheme.colors['success']
                                                              : AppTheme.colors['danger'],
                                                        ),
                                                        'Sentry User Interaction Tracing': Data(
                                                          value: _environmentConfig.sentryConfig!
                                                                  .enableUserInteractionTracing
                                                              ? 'enabled'
                                                              : 'disabled',
                                                          color: _environmentConfig.sentryConfig!
                                                                  .enableUserInteractionTracing
                                                              ? AppTheme.colors['success']
                                                              : AppTheme.colors['danger'],
                                                        ),
                                                        'Sentry Auto Performance Tracking': Data(
                                                          value: _environmentConfig.sentryConfig!
                                                                  .enableAutoPerformanceTracing
                                                              ? 'enabled'
                                                              : 'disabled',
                                                          color: _environmentConfig.sentryConfig!
                                                                  .enableAutoPerformanceTracing
                                                              ? AppTheme.colors['success']
                                                              : AppTheme.colors['danger'],
                                                        ),
                                                        'Sentry Assets Instrumentation': Data(
                                                          value: _environmentConfig.sentryConfig!
                                                                  .enableAssetsInstrumentation
                                                              ? 'enabled'
                                                              : 'disabled',
                                                          color: _environmentConfig.sentryConfig!
                                                                  .enableAssetsInstrumentation
                                                              ? AppTheme.colors['success']
                                                              : AppTheme.colors['danger'],
                                                        ),
                                                      },
                                                      if (null !=
                                                          _environmentConfig.datadogConfig) ...{
                                                        'DataDog Client Token': Data(
                                                          value: _environmentConfig
                                                              .datadogConfig!.clientToken,
                                                        ),
                                                        'DataDog Application Id': Data(
                                                          value: _environmentConfig
                                                              .datadogConfig!.applicationId,
                                                        ),
                                                        'DataDog Site': Data(
                                                          value: _environmentConfig
                                                              .datadogConfig!.site.name,
                                                        ),
                                                        'DataDog First Party Host': Data(
                                                          value: (
                                                            _environmentConfig
                                                                .datadogConfig!.firstPartyHosts,
                                                          ).toString(),
                                                        ),
                                                        'DataDog Traces Sample Rate': Data(
                                                          value: _environmentConfig
                                                              .datadogConfig!.tracesSampleRate
                                                              .toString(),
                                                        ),
                                                        'DataDog Native Crash report': Data(
                                                          value: _environmentConfig.datadogConfig!
                                                                  .nativeCrashReportEnabled
                                                              ? 'enabled'
                                                              : 'disabled',
                                                          color: _environmentConfig.datadogConfig!
                                                                  .nativeCrashReportEnabled
                                                              ? AppTheme.colors['success']
                                                              : AppTheme.colors['danger'],
                                                        ),
                                                        'DataDog Report Flutter Performance': Data(
                                                          value: _environmentConfig.datadogConfig!
                                                                  .reportFlutterPerformance
                                                              ? 'enabled'
                                                              : 'disabled',
                                                          color: _environmentConfig.datadogConfig!
                                                                  .reportFlutterPerformance
                                                              ? AppTheme.colors['success']
                                                              : AppTheme.colors['danger'],
                                                        ),
                                                      },
                                                    },
                                                  ),
                                                ),
                                                if (_environmentConfig.oneSignalConfig != null) ...[
                                                  verticalMargin24,
                                                  _NotificationSection(
                                                    oneSignalConfig:
                                                        _environmentConfig.oneSignalConfig!,
                                                  ),
                                                ],
                                                verticalMargin24,
                                                const _ProxySection(),
                                                verticalMargin24,
                                              ],
                                            ),
                                          ),
                                        ),
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
    required this.handleHeight,
    required this.onHandlePressed,
    required this.config,
    required this.child,
  });

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

class _NotificationSection extends StatelessWidget {
  final OneSignalConfig oneSignalConfig;

  const _NotificationSection({
    required this.oneSignalConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Notification Section'),
        verticalMargin8,
        _ShowDetails(
          contentHolder: PanelDataContentHolder(
            content: {
              'One Signal App Id': Data(value: oneSignalConfig.appId),
            },
          ),
        ),
      ],
    );
  }
}

class _ProxySection extends StatefulWidget {
  const _ProxySection();

  @override
  State<_ProxySection> createState() => _ProxySectionState();
}

class _ProxySectionState extends State<_ProxySection> {
  final TextEditingController _controller = TextEditingController();
  final RootAssetsController _assetController = Get.find<RootAssetsController>();

  @override
  void initState() {
    super.initState();
    _controller.text = _assetController.proxy ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: InputText(
            controller: _controller,
            label: 'Proxy',
          ),
        ),
        horizontalMargin8,
        ButtonElevated(
          text: 'Save',
          borderRadius: defaultPadding * 0.75,
          foregroundColor: AppTheme.colors['white'],
          backgroundColor: AppTheme.colors['primary'],
          onPressed: () => _assetController.proxy = _controller.text,
        ),
      ],
    );
  }
}

class _ShowDetails extends StatefulWidget {
  final PanelContentHolder contentHolder;

  const _ShowDetails({
    required this.contentHolder,
  });

  @override
  State<_ShowDetails> createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<_ShowDetails> {
  @override
  Widget build(BuildContext context) {
    final PanelContentHolder contentHolder = widget.contentHolder;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contentHolder is PanelDataContentHolder)
          Builder(
            builder: (context) {
              final List<TableRow> rows = [];
              contentHolder.content.forEach(
                (key, data) {
                  rows.add(
                    TableRow(
                      children: [
                        Padding(
                          padding: allPadding8,
                          child: Text(key),
                        ),
                        Padding(
                          padding: allPadding8,
                          child: SelectableText(
                            data.value ?? '',
                            style: TextStyle(color: data.color ?? AppTheme.colors['warning']),
                          ),
                        ),
                      ],
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppTheme.colors['white']!.withOpacity(0.55)),
                        ),
                      ),
                    ),
                  );
                },
              );
              return Table(
                children: rows,
              );
            },
          ),
      ],
    );
  }
}

abstract class PanelContentHolder {
  const PanelContentHolder();
}

class PanelDataContentHolder extends PanelContentHolder {
  final Map<String, Data> content;

  const PanelDataContentHolder({
    required this.content,
  });
}

class Data {
  final String? value;
  final String? tooltip;
  final Color? color;

  const Data({
    this.value,
    this.tooltip,
    this.color,
  });
}

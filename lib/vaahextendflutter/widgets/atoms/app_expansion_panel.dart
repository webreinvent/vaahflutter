import 'package:flutter/material.dart' hide ExpansionPanel;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team/vaahextendflutter/app_theme.dart';

final _expansionTween = CurveTween(curve: Curves.fastOutSlowIn);
final _iconTurnTween = Tween<double>(begin: 0.0, end: 0.5) //
    .chain(_expansionTween);

abstract class ExpansionControl {
  abstract bool expanded;
}

typedef ExpansionHeaderBuilder = Widget Function(BuildContext context, ExpansionControl control);

@immutable
class AppExpansionPanel extends StatefulWidget {
  const AppExpansionPanel({
    Key? key,
    required this.headerBuilder,
    required this.children,
    this.expanded = false,
    this.padding = EdgeInsets.zero,
    this.border = true,
    this.textStyle,
  }) : super(key: key);

  final ExpansionHeaderBuilder headerBuilder;
  final List<Widget> children;
  final bool expanded;
  final EdgeInsets padding;
  final bool border;
  final TextStyle? textStyle;

  @override
  State<AppExpansionPanel> createState() => _AppExpansionPanelState();
}

class _AppExpansionPanelState extends State<AppExpansionPanel>
    with SingleTickerProviderStateMixin, ExpansionControl {
  late AnimationController _controller;
  late Animation<double> _expansionAnim;
  late Animation<double> _iconTurns;

  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.expanded;
    _controller = AnimationController(duration: const Duration(milliseconds: 250), vsync: this);
    _controller.value = expanded ? _controller.upperBound : _controller.lowerBound;
    _expansionAnim = _controller.drive(_expansionTween);
    _iconTurns = _controller.drive(_iconTurnTween);
  }

  @override
  void didUpdateWidget(covariant AppExpansionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expanded != widget.expanded) {
      expanded = widget.expanded;
    }
  }

  @override
  bool get expanded => _expanded;

  @override
  set expanded(bool value) {
    if (_expanded == value) return;

    if (value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _expanded = value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: widget.border ? MaterialType.canvas : MaterialType.transparency,
      shape: widget.border ? AppTheme.panelBorder : null,
      textStyle: widget.textStyle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.headerBuilder(context, this),
          SizeTransition(
            axis: Axis.vertical,
            axisAlignment: -1.0,
            sizeFactor: _expansionAnim,
            child: Padding(
              padding: widget.padding - EdgeInsets.only(top: widget.padding.top),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class AppExpansionPanelIcon extends StatelessWidget {
  const AppExpansionPanelIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: context.findAncestorStateOfType<_AppExpansionPanelState>()!._iconTurns,
      child: FaIcon(
        FontAwesomeIcons.angleDown,
        color: AppTheme.colors['primary'],
      ),
    );
  }
}
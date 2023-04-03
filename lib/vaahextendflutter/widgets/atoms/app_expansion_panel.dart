import 'package:flutter/material.dart' hide ExpansionPanel;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app_theme.dart';
import '../../helpers/constants.dart';
import '../../helpers/styles.dart';

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
    this.headerBuilder,
    this.heading,
    required this.children,
    this.expanded = false,
    this.padding = EdgeInsets.zero,
    this.border = true,
    this.backgroundColor,
    this.textStyle,
  }) : super(key: key);

  final ExpansionHeaderBuilder? headerBuilder;
  final String? heading;
  final List<Widget> children;
  final bool expanded;
  final EdgeInsets padding;
  final bool border;
  final Color? backgroundColor;
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
      color: widget.backgroundColor ?? AppTheme.colors['black']!.shade50.withOpacity(0.5),
      shape: widget.border ? AppTheme.panelBorder : null,
      textStyle: widget.textStyle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.headerBuilder != null)
            widget.headerBuilder!(context, this)
          else
            defaultHeaderBuilder(context, this),
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

  Widget defaultHeaderBuilder(BuildContext context, ExpansionControl control) {
    return InkWell(
      onTap: () {
        control.expanded = !control.expanded;
      },
      child: Padding(
        padding: allPadding16,
        child: Row(
          children: [
            Expanded(
              child: Text(widget.heading ?? '', style: TextStyles.bold5),
            ),
            const AppExpansionPanelIcon(),
          ],
        ),
      ),
    );
  }
}

@immutable
class AppExpansionPanelIcon extends StatelessWidget {
  final Color? color;
  const AppExpansionPanelIcon({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: context.findAncestorStateOfType<_AppExpansionPanelState>()!._iconTurns,
      child: FaIcon(
        FontAwesomeIcons.angleDown,
        color: color ?? AppTheme.colors['primary'],
      ),
    );
  }
}

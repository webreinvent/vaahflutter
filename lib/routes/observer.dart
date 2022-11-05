import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class RouteAwareWidget extends StatefulWidget {
  final String name;
  final Widget child;

  const RouteAwareWidget({super.key, required this.name, required this.child});

  @override
  State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    Console.info('didPush ${widget.name}');
  }

  @override
  void didPopNext() {
    Console.info('didPopNext ${widget.name}');
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

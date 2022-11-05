import 'package:flutter/material.dart';
import 'package:team/routes/observer.dart';
import 'package:team/vaahextendflutter/base/base_stateful.dart';

class MoreDetailsPage extends StatefulWidget {
  static const String routeName = '/more-details';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/more-details'),
      builder: (_) => const RouteAwareWidget(
        name: '/more-details',
        child: MoreDetailsPage(),
      ),
    );
  }

  const MoreDetailsPage({super.key});

  @override
  State<MoreDetailsPage> createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends BaseStateful<MoreDetailsPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Back',
          ),
        ),
      ),
    );
  }
}

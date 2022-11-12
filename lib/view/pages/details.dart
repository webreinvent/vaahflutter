import 'package:flutter/material.dart';
import 'package:team/models/user.dart';
import 'package:team/vaahextendflutter/base/base_stateful.dart';
import 'package:team/view/pages/more_details.dart';
import 'package:team/view/pages/permission_denied.dart';

class DetailsPage extends StatefulWidget {
  static const String routeName = '/details';

  static Route<void> route() {
    if (!User.hasPermission('can-access-details')) {
      return PermissionDenied.route();
    }
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/details'),
      builder: (_) => const DetailsPage(),
    );
  }

  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends BaseStateful<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, MoreDetailsPage.routeName),
          child: const Text(
            'More Details',
          ),
        ),
      ),
    );
  }
}

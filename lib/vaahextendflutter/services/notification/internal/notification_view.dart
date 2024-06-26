import 'package:flutter/material.dart';

import '../../../env/env.dart';
import '../../../env/notification.dart';
import '../../../helpers/constants.dart';
import 'notification.dart';

class InternalNotificationsBadge extends StatefulWidget {
  const InternalNotificationsBadge({Key? key}) : super(key: key);

  @override
  State<InternalNotificationsBadge> createState() => _InternalNotificationsBadgeState();
}

class _InternalNotificationsBadgeState extends State<InternalNotificationsBadge> {
  final EnvironmentConfig _environmentConfig = EnvironmentConfig.getConfig;

  @override
  Widget build(BuildContext context) {
    return _environmentConfig.internalNotificationsServiceType.isNone
        ? emptyWidget
        : StreamBuilder(
            initialData: 0,
            stream: InternalNotifications.pendingNotificationsCountStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, InternalNotificationsView.route()),
                    child: Center(
                      child: Badge(
                        isLabelVisible: snapshot.data != 0,
                        label: Text(snapshot.data.toString()),
                        child: const Icon(Icons.notifications_none_rounded),
                      ),
                    ),
                  ),
                );
              } else {
                return emptyWidget;
              }
            },
          );
  }
}

class InternalNotificationsView extends StatefulWidget {
  static const String routePath = '/notifications';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routePath),
      builder: (_) => const InternalNotificationsView(),
    );
  }

  const InternalNotificationsView({Key? key}) : super(key: key);

  @override
  State<InternalNotificationsView> createState() => _InternalNotificationsViewState();
}

class _InternalNotificationsViewState extends State<InternalNotificationsView> {
  final double _borderRadius = defaultMargin / 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: allPadding16,
        child: StreamBuilder(
          initialData: InternalNotifications.notifications,
          stream: InternalNotifications.notificationsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Padding(
                  padding: bottomPadding8,
                  child: GestureDetector(
                    onTap: () {
                      if (snapshot.data![index].payload != null &&
                          snapshot.data![index].payload['path'] != null) {
                        Navigator.pushNamed(
                          context,
                          snapshot.data![index].payload['path'],
                          arguments: <String, dynamic>{
                            'data': snapshot.data![index].payload['data'],
                            'auth': snapshot.data![index].payload['auth'],
                          },
                        );
                      }
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_borderRadius),
                      ),
                      child: Column(
                        children: [
                          if (snapshot.data![index].imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(_borderRadius),
                                topRight: Radius.circular(_borderRadius),
                              ),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  snapshot.data![index].imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ListTile(
                            title: snapshot.data![index].heading == null
                                ? Text(snapshot.data![index].content)
                                : Text(snapshot.data![index].heading!),
                            subtitle: snapshot.data![index].heading != null
                                ? Text(snapshot.data![index].content)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Text('Come back later!');
            }
          },
        ),
      ),
    );
  }
}

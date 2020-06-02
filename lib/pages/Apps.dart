import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:android_intent/android_intent.dart';

import '../components/FixedContainer.dart';
import '../components/SearchableAppList.dart';

class Option extends StatelessWidget {
  void Function() onTap;
  Widget child;

  Option({ this.child, this.onTap }): super();

  @override
  build(BuildContext ctx) {
    return Column(
      children: [
        ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            title: child,
            onTap: () {
              onTap();
              Navigator.pop(ctx);
            },
        ),
        Divider(height: 1.0),
      ],
    );
  }
}

class AppsView extends StatelessWidget {
  Future<List<Application>> appListF = DeviceApps.getInstalledApplications(
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
  );

  void openApp(Application app) {
    DeviceApps.openApp(app.packageName);
  }

  void openOptionsMenu(BuildContext ctx, Application app) {
    showDialog(context: ctx, builder: (BuildContext ctx) => buildOptionsMenu(ctx, app));
  }

  Widget buildOptionsMenu(BuildContext ctx, Application app) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 300.0,
        width: 300.0,
        child: ListView(
          children: [
            Option(child: Text('App Settings'), onTap: () async {
              await AndroidIntent(
                  action: 'action_application_details_settings',
                  data: 'package:${app.packageName}',
              ).launch();
            }),
            Option(child: Text('Uninstall'),  onTap: () async {
              // FIXME: Doesn't work
              await AndroidIntent(
                  action: 'action_delete',
                  data: 'package:${app.packageName}',
              ).launch();
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return FixedContainer(
        padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
        child: SearchableAppList(
            appListF: appListF,
            openApp: openApp,
            openOptionsMenu: (app) => openOptionsMenu(ctx, app),
        ),
    );
  }
}


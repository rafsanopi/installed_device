import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Application> apps = [];

  getMyInstalledApps() async {
    List<Application> selectedApps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true);

    setState(() {
      apps.addAll(selectedApps);
    });

    print(apps);
  }

  @override
  void initState() {
    getMyInstalledApps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Installed Apps in my device",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: DeviceApps.getInstalledApplications(
                    includeAppIcons: true,
                    onlyAppsWithLaunchIntent: true,
                    includeSystemApps: true),
                builder: (context, AsyncSnapshot<List<Application>> data) {
                  if (data.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      Application app = apps[index];

                      return ListTile(
                        leading: app is ApplicationWithIcon
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(app.icon),
                                backgroundColor: Colors.white,
                              )
                            : null,
                        title: Text('${app.appName} (${app.packageName})'),
                        subtitle: Text('Version: ${app.versionName}\n'
                            'System app: ${app.systemApp}\n'
                            'APK file path: ${app.apkFilePath}\n'
                            'Data dir: ${app.dataDir}\n'
                            'Installed: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}\n'
                            'Updated: ${DateTime.fromMillisecondsSinceEpoch(app.updateTimeMillis).toString()}'),
                      );
                    },
                  );
                },
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.all(20),
            //   child: Text(
            //     "Package Name",
            //     style: TextStyle(fontSize: 20),
            //   ),
            // ),
            // Expanded(
            //   child: ListView.builder(
            //     padding: const EdgeInsets.all(20),
            //     itemCount: apps.length,
            //     itemBuilder: (context, index) {
            //       Application myapp = apps[index];
            //       return Text(myapp.packageName);
            //     },
            //   ),
            // )
          ],
        ));
  }
}

import 'package:flutter/material.dart';

class MyDestination {
  const MyDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<MyDestination> destinations = <MyDestination>[
  MyDestination('主页', Icon(Icons.home_outlined), Icon(Icons.home)),
  MyDestination('日结', Icon(Icons.edit_outlined), Icon(Icons.edit)),
  MyDestination('报表', Icon(Icons.summarize_outlined), Icon(Icons.summarize)),
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() =>
      _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 0;
  late bool showNavigationDrawer;

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  Widget buildBottomBarScaffold() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Page Index =  $screenIndex'),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: screenIndex,
        onDestinationSelected: handleScreenChanged,
        destinations: destinations.map(
          (MyDestination destination) {
            return NavigationDestination(
              label: destination.label,
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              tooltip: destination.label,
            );
          },
        ).toList(),
      ),
    );
  }

  Widget buildDrawerScaffold(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          bottom: false,
          top: false,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: NavigationRail(
                  minExtendedWidth: 170,
                  extended: constraints.maxWidth >= 700,
                  destinations: destinations.map(
                    (MyDestination destination) {
                      return NavigationRailDestination(
                        label: Text(destination.label),
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                      );
                    },
                  ).toList(),
                  selectedIndex: screenIndex,
                  useIndicator: true,
                  onDestinationSelected: (int index) {
                    setState(() {
                      screenIndex = index;
                    });
                  },
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Page Index =  $screenIndex'),
                    ElevatedButton(
                      onPressed: null,
                      child: const Text('Open Drawer'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        endDrawer: NavigationDrawer(
          onDestinationSelected: handleScreenChanged,
          selectedIndex: screenIndex,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
              child: Text(
                'Header',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ...destinations.map(
              (MyDestination destination) {
                return NavigationDrawerDestination(
                  label: Text(destination.label),
                  icon: destination.icon,
                  selectedIcon: destination.selectedIcon,
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
              child: Divider(),
            ),
          ],
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= 450;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationDrawer
        ? buildDrawerScaffold(context)
        : buildBottomBarScaffold();
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Home(),
    ),
  );
}

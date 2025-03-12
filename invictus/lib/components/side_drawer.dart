import 'package:flutter/material.dart';
import 'package:invictus/main.dart';
import 'package:invictus/pages/market.dart';
import 'package:invictus/pages/yield.dart';
import 'package:invictus/theme.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SideDrawer extends StatelessWidget {
  const SideDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      backgroundColor: Color(0xFF1E1F25),
      child: ListView(
        children: [
          SizedBox(
              height: 0.1 * queryData.size.height,
              width: 0.3 * queryData.size.width,
              // child: Image.asset("assets/shaastra_2025_white.png")
              child: Center(
                // child: const Text(
                // "INVICTUS",
                // style: TextStyle(
                //   fontSize: 25,
                //   color: Colors.white
                // ),
                // )
                )),
          const Divider(
            thickness: 0.5,
          ),
          SizedBox(
              height: 0.65 * queryData.size.height,
              //width: 100,
              child: RawScrollbar(
                thumbColor: const Color(0xFFAFB0BE),
                radius: const Radius.circular(18.0),
                trackVisibility: true,
                thickness: 5,
                controller: ScrollController(),
                thumbVisibility: true,
                scrollbarOrientation: ScrollbarOrientation.left,
                // minOverscrollLength: 30,
                minThumbLength: 50,
                child: ListView(
                  // controller: ScrollController(),
                  children: [
                    DrawerTiles(
                      label: 'Market',
                      tileicon: Icons.work,
                      page: Market(),
                    ),
                    DrawerTiles(
                      label: 'Yield Report',
                      tileicon: Icons.image,
                      page: YieldReport(),
                    ),
                    DrawerTiles(
                      label: 'Notifications',
                      tileicon: Icons.notifications,
                      page: Market(),
                    ),
                    DrawerTiles(
                      label: 'Profile',
                      tileicon: Icons.person,
                      page: Market(),
                    ),
                    ElevatedButton(
          onPressed: themeProvider.toggleTheme,
          child: const Text('Toggle Theme'),
        ),
                  ],
                ),
              )),
          const Divider(
            thickness: 0.5,
          ),
          SizedBox(
            height: 0.15 * queryData.size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Developed by ",
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Colors.white54,
                      fontSize: 14.5,
                    ),
                  ),
                  Text(
                    "Team INVICTUS",
                    style: TextStyle(
                      fontFamily: "Poppins-Regular",
                      color: Colors.white54,
                      fontSize: 14.5,
                    ),
                  ),
                  // Text(
                  //   "with ❤️",
                  //   style: TextStyle(
                  //     fontFamily: "Poppins-Regular",
                  //     color: Colors.deepPurple[200],
                  //     fontSize: 14.5,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerTiles extends StatelessWidget {
  const DrawerTiles({
    super.key,
    required this.label,
    required this.tileicon,
    required this.page,
  });

  final String label;
  final IconData tileicon;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(
          tileicon,
          size: 22,
          color: Colors.white,
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontFamily: "Poppins-Regular",
            fontSize: 14,
            color: Colors.white54
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
          //Navigation(label);
        },
        minVerticalPadding: 5,
      ),
    );
  }
}

// ignore: must_be_immutable
class DrawerBuilder extends StatefulWidget {
  const DrawerBuilder({super.key});

  @override
  State<DrawerBuilder> createState() => _DrawerBuilderState();
}

class _DrawerBuilderState extends State<DrawerBuilder> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.menu,
            size: 35,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    );
  }
}

Future<dynamic> logoutAlert(BuildContext context, Function callback, auth) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, _) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            actionsPadding: const EdgeInsets.all(10),
            title: const Text(
              'Logout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Are you sure to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins-Regular",
                  fontSize: 17,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: "Poppins-Regular",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.deepPurple),
                  )),
            ],
          );
        });
      });
}

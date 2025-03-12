import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:invictus/components/side_drawer.dart';
import 'package:invictus/pages/chatbot.dart';
import 'package:invictus/pages/community.dart';
import 'package:invictus/pages/home.dart';
import 'package:invictus/pages/scan.dart';
import 'package:invictus/pages/weather.dart';

class BottomBar extends StatefulWidget {
  BottomBar(
    {required this.currentindex ,super.key}
  );
  int currentindex = 0;
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final User? theuser = FirebaseAuth.instance.currentUser;

  late List<Widget> pagelist;

  @override
  void initState() {
    super.initState();
    pagelist = [const Home(), Chatbot(), const Scan(), const WeatherScreen(), Community(user: theuser,)];
  }
  List<String> titlelist = ["Home", "Chatbot", "Weather", "Plant Disease Detection", "Farmers Chatroom"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF1E1F25),
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   // leading: const DrawerBuilder(),
      //   title: Text(
      //     titlelist[currentindex],
      //     style: const TextStyle(
      //       color: Colors.black
      //     ),
      //   ),
      //   // backgroundColor: const Color(0xFF1E1F25),
      //   backgroundColor: Colors.green,

      // ),
      // drawer: const SideDrawer(),
      body: SafeArea(
        top: true,
        child: pagelist[widget.currentindex],
      ),
      bottomNavigationBar: GNav(
        onTabChange: (index) => setState(() {
            widget.currentindex = index;
          }),
          selectedIndex: widget.currentindex,
          rippleColor: Colors.grey, // tab button ripple color when pressed
          hoverColor: Colors.white, // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 30,
          // backgroundColor: const Color(0xFF232530),
          backgroundColor: Colors.black,
          // tabActiveBorder:
          //     Border.all(color: Colors.black, width: 1), // tab button border
          // tabBorder:
          //     Border.all(color: Colors.grey, width: 1), // tab button border
          // tabShadow: [
          //   BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
          // ], // tab button shadow
          curve: Curves.easeOutExpo, // tab animation curves
          duration: const Duration(milliseconds: 900), // tab animation duration
          gap: 2, // the tab button gap between icon and text
          color: Colors.white, // unselected icon color
          activeColor: Colors.green, // selected icon and text color
          iconSize: 22, // tab button icon size
          // tabBackgroundColor:const Color(0xFF2C2B3E), // selected tab background color
          tabBackgroundColor:Colors.black, // selected tab background color
          // tabMargin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 15), // navigation bar padding
          tabs: const [
            GButton(
              icon: Icons.home_max_rounded,
              text: 'Home',
            ),
            GButton(
              icon: Icons.chat_bubble_outline_rounded,
              text: 'Chatbot',
            ),
            GButton(
              icon: Icons.document_scanner,
              text: 'Scan',
              iconSize: 40,
            ),
            GButton(
              icon: Icons.sunny_snowing,
              text: 'Weather',
            ),
            GButton(
              icon: Icons.supervised_user_circle_rounded,
              text: 'Chat',
            )
          ]),
    );
  }
}

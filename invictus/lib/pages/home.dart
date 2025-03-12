import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:invictus/components/form.dart';
import 'package:invictus/components/post.dart';
import 'package:invictus/pages/bottombar.dart';
import 'package:invictus/pages/market.dart';
import 'package:invictus/pages/profile.dart';
import 'package:invictus/pages/schemes.dart';
import 'package:invictus/pages/yield.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 245, 245, 211),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/home.jpg"), // Change to your image path
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Container(
              //   height: queryData.size.width,
              //   width: queryData.size.width,
              //   decoration: BoxDecoration(
              //     color: Colors.green,
              //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
              //   ),
              //   child: Image.asset(
              //     "assets/images/home1.jpeg",
              //   ),
              // )

              // Stack(
              //   children: [
              //     ClipRRect(
              //       child: Container(
              //         height: queryData.size.height * 0.25,
              //         width: queryData.size.width,
              //         decoration: const BoxDecoration(
              //           color: Color.fromARGB(255, 245, 245, 211),
              //           borderRadius: BorderRadius.only(
              //             bottomLeft: Radius.circular(25),
              //             bottomRight: Radius.circular(25),
              //           ),
              //         ),
              //         // child: ClipRRect(
              //         //   borderRadius: const BorderRadius.only(
              //         //     bottomLeft: Radius.circular(25),
              //         //     bottomRight: Radius.circular(25),
              //         //   ),
              //         //   child: Image.asset(
              //         //     "assets/images/home1.jpeg",
              //         //     fit: BoxFit
              //         //         .cover, // Ensures the image covers the container
              //         //   ),
              //         // ),
              //       ),
              //     ),
              //     Positioned(
              //       top: 10, // Adjust based on your need
              //       left: 10,
              //       // right: 20,
              //       child: Container(
              //         // color: Colors.green,
              //         child: const Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "Hello,",
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.bold,
              //                 // backgroundColor: Colors.black54, // Optional: adds slight background to text
              //               ),
              //             ),
              //             Text(
              //               "Kaustubh ",
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.bold,
              //                 // backgroundColor: Colors.black54, // Optional: adds slight background to text
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     Positioned(
              //       bottom: -10,
              //       child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: [
              //               HomeNavButton(queryData: queryData, title: 'Yield Report', icon: Icons.file_open_outlined, widget: YieldReport(),),
              //               HomeNavButton(queryData: queryData, title: 'Market', icon: Icons.shop_outlined, widget: Market(),),
              //               HomeNavButton(queryData: queryData, title: 'Schemes', icon: Icons.schema, widget: SchemesPage(),),
              //             ],
              //           ),
              //         ),
              //     ),
              //   ],
              // ),

              Stack(
                clipBehavior: Clip.none, // Allows overflow for floating effect
                children: [
                  // Background Container
                  Container(
                    height: queryData.size.height * 0.12,
                    width: queryData.size.width,
                    // decoration: const BoxDecoration(
                    //   // color: Color.fromARGB(255, 245, 245, 211),
                    //   // borderRadius: BorderRadius.only(
                    //   //   bottomLeft: Radius.circular(25),
                    //   //   bottomRight: Radius.circular(25),
                    //   // ),
                    // ),
                  ),

                  // Floating Text
                  Positioned(
                    top: 20, // Adjust as needed
                    left: 20,
                    child: Container(
                      width: queryData.size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello,",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${user?.displayName}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : AssetImage("assets/default_profile.png") as ImageProvider,
              ),
            ),
          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating Button Row
                  // Positioned(
                  //   bottom: -30, // Move row of buttons partially out of the container
                  //   left: 0,
                  //   right: 0,
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white, // Background for button row
                  //         borderRadius: BorderRadius.circular(20),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.black26,
                  //             blurRadius: 10,
                  //             offset: Offset(0, 4),
                  //           ),
                  //         ],
                  //       ),
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           HomeNavButton(queryData: queryData, title: 'Yield Report', icon: Icons.file_open_outlined, widget: YieldReport(),),
                  //           HomeNavButton(queryData: queryData, title: 'Market', icon: Icons.shop_outlined, widget: Market(),),
                  //           HomeNavButton(queryData: queryData, title: 'Schemes', icon: Icons.schema, widget: SchemesPage(),),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Material(
                    // elevation: 2.0,
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: queryData.size.width,
                      // color: Colors.blue,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(25),
                      //   // color: Color.fromARGB(255, 100, 182, 103),
                      //   // color: Colors.black.withOpacity(0.1),
                      //   color: Colors.transparent
                      // ),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              HomeNavButton(
                                queryData: queryData,
                                title: 'Yield Report',
                                icon: Icons.file_open_outlined,
                                widget: CropInputForm(),
                              ),
                              HomeNavButton(
                                queryData: queryData,
                                title: 'Market',
                                icon: Icons.shop_outlined,
                                widget: Market(),
                              ),
                              HomeNavButton(
                                queryData: queryData,
                                title: 'Schemes',
                                icon: Icons.schema,
                                widget: SchemesPage(),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                // color: Colors.white,
                                height: queryData.size.height * 0.122,
                                width: queryData.size.width,
                                decoration: BoxDecoration(
                                    // border: Border.all(
                                    //     color: const Color.fromARGB(255, 63, 36, 36)),
                                    borderRadius: BorderRadius.circular(25)),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomBar(currentindex: 3)),
    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: const Text(
                                          "Today's Weather",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.wb_sunny_outlined,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                "30°C ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  // backgroundColor: Colors.black54, // Optional: adds slight background to text
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.water_drop_outlined,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                "50 %",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  // backgroundColor: Colors.black54, // Optional: adds slight background to text
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Material(
                                          //   // elevation: 2.0,
                                          //   borderRadius: BorderRadius.circular(25),
                                          //   child: Stack(
                                          //     children: [
                                          //       Container(
                                          //         height: 90,
                                          //         width: queryData.size.width * 0.4,
                                          //         decoration: BoxDecoration(
                                          //           color: Colors.white,
                                          //           borderRadius:
                                          //               BorderRadius.circular(25),
                                          //         ),
                                          //         child: ClipRRect(
                                          //           borderRadius:BorderRadius.circular(25),
                                          //           child: Icon(Icons.water_drop_outlined),
                                          //         ),
                                          //       ),
                                          //       const Positioned(
                                          //         top: 10, // Adjust based on your need
                                          //         right: 10,
                                          //         // right: 20,
                                          //         child: Text(
                                          //           "50%",
                                          //           textAlign: TextAlign.center,
                                          //           style: TextStyle(
                                          //             color: Colors.black87,
                                          //             fontSize: 27,
                                          //             fontWeight: FontWeight.bold,
                                          //             // backgroundColor: Colors.black54, // Optional: adds slight background to text
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          Icon(
                                            Icons.arrow_right,
                                            color: Colors.green,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(25.0),
                              child: Container(
                                height: queryData.size.height * 0.1,
                                width: queryData.size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.white,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomBar(currentindex: 2)),
    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "Scan Image of Vegetable",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Image.asset(
                                        "assets/images/test.jpg",
                                        width: queryData.size.width * 0.2,
                                      ),
                                      const Icon(
                                        Icons.arrow_right,
                                        color: Colors.green,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Post(
                            profileImage:
                                'https://media.istockphoto.com/id/543212762/photo/tractor-cultivating-field-at-spring.jpg?s=612x612&w=0&k=20&c=uJDy7MECNZeHDKfUrLNeQuT7A1IqQe89lmLREhjIJYU=',
                            username: 'UP Government',
                            postImage:
                                'https://media.istockphoto.com/id/543212762/photo/tractor-cultivating-field-at-spring.jpg?s=612x612&w=0&k=20&c=uJDy7MECNZeHDKfUrLNeQuT7A1IqQe89lmLREhjIJYU=',
                            likes: 10,
                            caption: 'UP Kisan Samman Nidhi - 17th',
                            description:
                                '💰 ₹2000 Direct Benefit Transfer*  ✅ *Coverage:* 2.35 crore UP farmers  ✅ *e-KYC Deadline:* 31 July 2024  ✅ *Payment Schedule:*  - West UP: 15-20 July  - East UP: 20-25 July  - Bundelkhand: 25-30 July  ',
                            link:
                                'https://upkisan.gov.in',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeNavButton extends StatelessWidget {
  const HomeNavButton({
    super.key,
    required this.queryData,
    required this.title,
    required this.icon,
    required this.widget,
  });

  final MediaQueryData queryData;
  final String title;
  final IconData icon;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: queryData.size.height * 0.15,
        width: queryData.size.width * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => widget),
                );
              },
              icon: Icon(
                icon,
                color: Colors.black,
                size: 33,
              ),
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}

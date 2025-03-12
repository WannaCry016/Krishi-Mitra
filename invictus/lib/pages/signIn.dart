import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invictus/onboarding.dart';
import 'package:invictus/pages/bottombar.dart';
import 'package:invictus/sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Firebase OAuth")),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/signin.jpg"), // Change to your image path
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "INVICTUS",
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "Welcome! To our app",
            //     style: TextStyle(
            //       fontSize: 17,
            //       color: Colors.white,
            //       fontWeight: FontWeight.w100
            //     ),
            //   ),
            // ),

            Column(
              children: [
                SignInButton(
                  Buttons.google,
                  onPressed: () async {
                    UserCredential? userCredential = await signInWithGoogle();
                    setState(() {
                      _user = userCredential?.user;
                    });
                    if (userCredential != null) {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => BottomBar(currentindex: 0)),
                      // );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnboardingScreen()),
                      );
                    }
                  },
                  text: "Sign in with Google",
                ),
                // SignInButton(
                //   Buttons.gitHub,
                //   onPressed: () async {
                //     UserCredential? userCredential = await signInWithGitHub();
                //     setState(() {
                //       _user = userCredential?.user;
                //     });
                //     if (userCredential != null) {
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => BottomBar(currentindex: 0)),
                //       );
                //     }
                //   },
                //   text: "Sign in with Github",
                // ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

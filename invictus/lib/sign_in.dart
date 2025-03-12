import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    
    // Ensure a fresh login by signing out first
    await googleSignIn.signOut();  // <-- This forces account selection

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (error) {
    print('Sign-in error: $error');
    return null;
  }
}





// // Replace with your GitHub OAuth credentials
// const String clientId = "Ov23lilnPQQ22zvUzyGd";
// const String clientSecret = "";
// const String redirectUri = "https://invictus-8f34a.firebaseapp.com/__/auth/handler";

// Future<UserCredential?> signInWithGitHub() async {
//   try {
//     // 1️⃣ Open GitHub login page and get authorization code
//     final result = await FlutterWebAuth.authenticate(
//       url: "https://github.com/login/oauth/authorize"
//           "?client_id=$clientId"
//           "&redirect_uri=$redirectUri"
//           "&scope=read:user,user:email",
//       callbackUrlScheme: "invictus-8f34a",
//     );

//     // Extract the authorization code from the callback URL
//     final code = Uri.parse(result).queryParameters['code'];

//     if (code == null) throw Exception("GitHub sign-in failed");

//     // 2️⃣ Exchange code for an access token
//     final response = await http.post(
//       Uri.parse("https://github.com/login/oauth/access_token"),
//       headers: {"Accept": "application/json"},
//       body: {
//         "client_id": clientId,
//         "client_secret": clientSecret,
//         "code": code,
//         "redirect_uri": redirectUri,
//       },
//     );

//     final accessToken = jsonDecode(response.body)["access_token"];
//     if (accessToken == null) throw Exception("GitHub authentication failed");

//     // 3️⃣ Authenticate with Firebase using the access token
//     final credential = GithubAuthProvider.credential(accessToken);
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   } catch (error) {
//     print("GitHub sign-in error: $error");
//     return null;
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invictus/firebase_options.dart';
import 'package:invictus/pages/bottombar.dart';
import 'package:invictus/pages/home.dart';
import 'package:invictus/pages/scan.dart';
import 'package:invictus/pages/signIn.dart';
import 'package:invictus/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:invictus/theme.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
 var status = await Permission.microphone.request();
  if (status.isDenied) {
    print("Microphone permission denied");
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Theme Toggle',
            theme: lightTheme,
            // darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            // home: const SplashScreen(),
            home: AuthWrapper(),
          );
        },
      ),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data != null) {
          return BottomBar(currentindex: 0); // Navigate to bottom navigation bar
        } else {
          return SignInScreen(); // Show sign-in page
        }
      },
    );
  }
}
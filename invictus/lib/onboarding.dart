import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:invictus/pages/bottombar.dart';

Position? userLocation; // Global variable to store location

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 4) {
      _controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the main app screen
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permission denied");
      if (permission == LocationPermission.deniedForever) {
      // Handle case where user permanently denies permission
      print('Location permissions are permanently denied.');
    }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar(currentindex: 0)),
      );
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      userLocation = position; // Store in global variable
      print("Location: ${userLocation!.latitude}, ${userLocation!.longitude}");
      print("Location permission granted");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar(currentindex: 0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Welcome to",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontFamily: "Poppins-Regular",
                      fontWeight: FontWeight.w100
                    )
                  ),
                ),
                RichText(
              text: TextSpan(
                text: "INVICTUS",
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.black,
                      fontFamily: "Poppins-Regular",
                      fontWeight: FontWeight.bold

                )
              ),
            ),
              ],
            ),
          ),
          FeaturePage(title: "Krishi Mitra Chatbot", description: "A chatbot to ask queries related to farming.", image: "assets/onboarding/chatbot.jpg",),
          FeaturePage(
              title: "Disease Detection", description: "Scan images of plants to know about the diseases.", image: "assets/onboarding/scan.jpg",),
          FeaturePage(title: "Community", description: "Connect with other farmers.", image: "assets/onboarding/community.jpg",),
          LocationAccessPage(
            onAllow: _requestLocationPermission, image: "assets/onboarding/location.jpg",
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentPage < 4
            ? ElevatedButton(
              
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                elevation: MaterialStateProperty.all(5.0),
              ),
                onPressed: _nextPage,
                child: Text("Next", style: TextStyle(color: Colors.white)),
              )
            : SizedBox(), // Hide Next button on last page
      ),
    );
  }
}

class FeaturePage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  FeaturePage({required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 300, height: 300,),
          Text(title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class LocationAccessPage extends StatelessWidget {
  final VoidCallback onAllow;
  final String image;

  LocationAccessPage({required this.onAllow, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 300, height: 300,),
          Center(
            child: Text("Allow Location Access.",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
                ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text("We need location access for weather updates.",
                // style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
                ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            
            style: ButtonStyle(
        
                backgroundColor: MaterialStateProperty.all(Colors.green),
                elevation: MaterialStateProperty.all(5.0),
              ),
            onPressed: onAllow,
            child: Text("Allow", style: TextStyle(color: Colors.white),),
          ),
          TextButton(
            onPressed: () {
              // Skip action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomBar(currentindex: 0)),
              );
            },
            child: Text("Skip", style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    );
  }
}

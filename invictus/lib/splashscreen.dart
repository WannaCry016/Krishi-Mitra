import 'dart:async';
import 'package:flutter/material.dart';
import 'package:invictus/pages/bottombar.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // // video controller
  // // late VideoPlayerController _controller;

  // @override
  // void initState() {
  //   super.initState();

  //   // _controller = VideoPlayerController.asset(
  //   //   'assets/splashvideo.mp4',
  //   // )
  //   //   ..initialize().then((_) {
  //   //     setState(() {});
  //   //   })
  //   //   ..setVolume(0.0);

  //   _playVideo();
  // }

  // void _playVideo() async {
  //   // playing video
  //   // _controller.play();

  //   //add delay till video is complite
  //   await Future.delayed(const Duration(seconds: 4));

  //   // navigating to home screen
  //   // Navigator.pushNamed(context, '/');

  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => BottomBar(currentindex: 0)
  //       )
  //   );
  // }

  // // @override
  // // void dispose() {
  // //   // _controller.dispose();
  // //   super.dispose();
  // // }
  




  // video controller
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
  _controller = VideoPlayerController.asset('assets/splash.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((error) {
        print("Video Player Error: $error");
      });

  // Automatically navigate after 6 seconds
    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar(currentindex: 0)),
        );
      }
    });
  }

  // void _playVideo() async {
  //   // playing video
  //   _controller.play();

  //   //add delay till video is complite
  //   // await Future.delayed(const Duration(seconds: 4));

  //   // navigating to home screen
  //   // Navigator.pushNamed(context, '/');

  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => BottomBar(currentindex: 0)
  //       )
  //   );
  // }

//   void _navigateToHome() {
//   _controller.addListener(() {
//     if (_controller.value.position >= _controller.value.duration) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => BottomBar(currentindex: 0)),
//       );
//     }
//   });
// }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen video
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          // Floating text at the center
          const Center(
            child: Text(
              "INVICTUS", // Your floating text
              style: TextStyle(
                fontFamily: "Poppins-Regular",
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black54,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
            
      //       Container(
      //         height: 200,
      //         width: 200,
      //         // child: Image.asset("assets/shaastra_2025_white.png")
      //         child: Center(
      //           child: Text(
      //             "INVICTUS",
      //             style: TextStyle(
      //               fontFamily: "Poppins-Regular",
      //               fontSize: 25,
      //               color: Colors.white
      //             ),

      //           ),
      //         )
      //       ),
      //       SizedBox(height: 20),
      //       CircularProgressIndicator(
      //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

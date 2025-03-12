// import 'package:flutter/material.dart';

// class WeatherScreen extends StatefulWidget {
//   const WeatherScreen({super.key});

//   @override
//   State<WeatherScreen> createState() => _WeatherScreenState();
// }

// class _WeatherScreenState extends State<WeatherScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//             backgroundColor: Color(0xFF1E1F25),

//     );
//   }
// }

// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:invictus/onboarding.dart';

class WeatherData {
  final String date; // e.g., "14-02-2025"
  final String time;
  final int temperature;
  final double windSpeed; // in m/s
  final double precipitation;
  final String condition;

  WeatherData({
    required this.date,
    required this.time,
    required this.temperature,
    required this.windSpeed,
    required this.precipitation,
    required this.condition,
  });

  // Factory method to create WeatherData from JSON
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      date: json["date"], // Format: "14-02-2025"
      time: json["time"],
      temperature: json["temperature"].toInt(),
      windSpeed: json["wind_speed"].toDouble(),
      precipitation: json["precipitation"].toDouble(),
      condition: json["weather"],
    );
  }
}

// Function to get the appropriate weather icon
// IconData getWeatherIcon(String condition) {
//   switch (condition.toLowerCase()) {
//     case "clear sky":
//       return FontAwesomeIcons.sun;
//     case "partly cloudy":
//       return FontAwesomeIcons.cloudSun;
//     case "overcast":
//       return FontAwesomeIcons.cloud;
//     case "rain":
//       return FontAwesomeIcons.cloudRain;
//     default:
//       return FontAwesomeIcons.cloud; // Default fallback
//   }
// }

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, List<WeatherData>> groupedWeather = {}; // Grouped by date
  List<WeatherData> firstDayWeather = [];

  double lat = userLocation != null ? userLocation!.latitude : 13.0843; // Default: user location
  double lon = userLocation != null ?userLocation!.longitude : 80.2705;
  String cityName = "Chennai";
  TextEditingController searchController = TextEditingController();

  Future<void> fetchData() async {
    final url = Uri.parse('http://192.168.137.1:8000/weather/');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "lat": lat.toDouble(), // Ensure it's a float
        "lon": lon.toDouble(), // Ensure it's a float
      }),
    );

    var data = jsonDecode(response.body);

    print("data: ${data["forecast"]["2025-02-14"]}");

    if (response.statusCode == 200) {
      // List<dynamic> data = jsonDecode(response.body)["forecast"];
      // List<dynamic> data = jsonDecode(response.body);
      // List<WeatherData> forecast = data.map((json) => WeatherData.fromJson(json)).toList();
      Map<String, dynamic> forecastData =
          jsonDecode(response.body)["forecast"]; // Extract the map
      // Group weather data by date
      Map<String, List<WeatherData>> grouped = {};
      // Iterate over each date in the forecast data
      forecastData.forEach((date, weatherList) {
        if (weatherList is List<dynamic>) {
          List<WeatherData> dailyForecast = weatherList
              .map((json) => WeatherData.fromJson(
                  {...json, "date": date})) // Add date manually
              .toList();

          grouped[date] = dailyForecast;
        }
      });

      setState(() {
        groupedWeather = grouped;
        if (groupedWeather.isNotEmpty) {
          String firstDate = groupedWeather.entries.first.key; // First date
          List<WeatherData> _firstDayWeather =
              groupedWeather.entries.first.value; // Corresponding weather data

          setState(() {
            firstDayWeather = _firstDayWeather;
          });
          print("First Date: $firstDate");
          print("Weather Data: $_firstDayWeather");
        }
      });
      // return "ok";
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<void> fetchcoordinates() async {
    final String geoUrl =
        "https://us1.locationiq.com/v1/reverse?key=pk.92f5009bd00e373070479c0379cba5a9&lat=${userLocation!.latitude}&lon=${userLocation!.longitude}&format=json&";

    try {
      final response = await http.get(Uri.parse(geoUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            // lat = double.parse(jsonData[0]["lat"]);
            // lon = double.parse(jsonData[0]["lon"]);
            cityName = jsonData["display_name"];
          });

          print("Updated coords: $cityName, Lat: $lat, Lon: $lon");
          fetchData(); // Fetch weather with new location
        }
      } else {
        print("Failed to fetch coords: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching coords: $e");
    }
  }

  Future<void> fetchLatLon(String place) async {
    final String geoUrl =
        "https://us1.locationiq.com/v1/search?key=pk.92f5009bd00e373070479c0379cba5a9&q=$place&format=json&";

    try {
      final response = await http.get(Uri.parse(geoUrl));

      if (response.statusCode == 200) {
        final List jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            lat = double.parse(jsonData[0]["lat"]);
            lon = double.parse(jsonData[0]["lon"]);
            cityName = jsonData[0]["display_name"];
          });

          print("Updated Location: $cityName, Lat: $lat, Lon: $lon");
          fetchData(); // Fetch weather with new location
        }
      } else {
        print("Failed to fetch location: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case "clear sky":
        return FontAwesomeIcons.sun;
      case "partly cloudy":
        return FontAwesomeIcons.cloudSun;
      case "overcast":
        return FontAwesomeIcons.cloud;
      case "rain":
        return FontAwesomeIcons.cloudRain;
      default:
        return FontAwesomeIcons.cloud;
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
    return DateFormat("EEEE")
        .format(parsedDate); // Convert to "Monday", "Tuesday", etc.
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchcoordinates();
  }

  @override
  Widget build(BuildContext context) {
    // String cityName = "Katowice"; //city name
    int currTemp = 30; // current temperature
    int maxTemp = 30; // today max temperature
    int minTemp = 2; // today min temperature
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    // bool isDarkMode = brightness == Brightness.dark;
    bool isDarkMode = false;

    return Scaffold(
      // body: Center(
      //   child: FutureBuilder<String>(
      //     future: fetchData(12, 34),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return CircularProgressIndicator(); // Show loading
      //       } else if (snapshot.hasError) {
      //         return Text("Error: ${snapshot.error}"); // Show error
      //       } else {
      //         // return Text(snapshot.data ?? "No data"); // Show data
      //         return Stack(
      //           children: [
      //             Container(
      //               height: size.height,
      //               width: size.width,
      //               decoration: const BoxDecoration(
      //                 // color: Colors.green,
      //                 borderRadius: BorderRadius.only(
      //                   bottomLeft: Radius.circular(25),
      //                   bottomRight: Radius.circular(25),
      //                 ),
      //               ),
      //               child: ClipRRect(
      //                 borderRadius: const BorderRadius.only(
      //                   bottomLeft: Radius.circular(25),
      //                   bottomRight: Radius.circular(25),
      //                 ),
      //                 child: Image.asset(
      //                   "assets/images/weather.jpg",
      //                   fit: BoxFit
      //                       .cover, // Ensures the image covers the container
      //                 ),
      //               ),
      //             ),
      //             Positioned(
      //               child: Center(
      //                 child: Container(
      //                   height: size.height,
      //                   width: size.height,
      //                   decoration: BoxDecoration(
      //                       // color: isDarkMode ? Colors.black : Colors.white,
      //                       ),
      //                   child: SafeArea(
      //                     child: Stack(
      //                       children: [
      //                         SingleChildScrollView(
      //                           child: Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Padding(
      //                                 padding: EdgeInsets.symmetric(
      //                                   vertical: size.height * 0.01,
      //                                   horizontal: size.width * 0.05,
      //                                 ),
      //                                 child: Row(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.spaceBetween,
      //                                   children: [
      //                                     // FaIcon(
      //                                     //   FontAwesomeIcons.bars,
      //                                     //   color: isDarkMode ? Colors.white : Colors.black,
      //                                     // ),
      //                                     Align(
      //                                       child: Text(
      //                                         'Weather App', //TODO: change app name
      //                                         style: GoogleFonts.questrial(
      //                                           color: isDarkMode
      //                                               ? Colors.white
      //                                               : const Color(0xff1D1617),
      //                                           fontSize: size.height * 0.02,
      //                                         ),
      //                                       ),
      //                                     ),
      //                                     FaIcon(
      //                                       FontAwesomeIcons.plusCircle,
      //                                       color: isDarkMode
      //                                           ? Colors.white
      //                                           : Colors.black,
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: EdgeInsets.only(
      //                                   top: size.height * 0.03,
      //                                 ),
      //                                 child: Align(
      //                                   child: Text(
      //                                     cityName,
      //                                     style: GoogleFonts.questrial(
      //                                       color: isDarkMode
      //                                           ? Colors.white
      //                                           : Colors.black,
      //                                       fontSize: size.height * 0.05,
      //                                       fontWeight: FontWeight.bold,
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: EdgeInsets.only(
      //                                   top: size.height * 0.005,
      //                                 ),
      //                                 child: Align(
      //                                   child: Text(
      //                                     'Today', //day
      //                                     style: GoogleFonts.questrial(
      //                                       color: isDarkMode
      //                                           ? Colors.white54
      //                                           : Colors.black54,
      //                                       fontSize: size.height * 0.035,
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: EdgeInsets.only(
      //                                   top: size.height * 0.03,
      //                                 ),
      //                                 child: Align(
      //                                   child: Text(
      //                                     '$currTemp˚C', //curent temperature
      //                                     style: GoogleFonts.questrial(
      //                                       color: currTemp <= 0
      //                                           ? Colors.blue
      //                                           : currTemp > 0 && currTemp <= 15
      //                                               ? Colors.indigo
      //                                               : currTemp > 15 &&
      //                                                       currTemp < 30
      //                                                   ? Colors.deepPurple
      //                                                   : Colors.green,
      //                                       fontSize: size.height * 0.11,
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: EdgeInsets.symmetric(
      //                                     horizontal: size.width * 0.25),
      //                                 child: Divider(
      //                                   color: isDarkMode
      //                                       ? Colors.white
      //                                       : Colors.black,
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: EdgeInsets.only(
      //                                   top: size.height * 0.005,
      //                                 ),
      //                                 child: Align(
      //                                   child: Text(
      //                                     'Sunny', // weather
      //                                     style: GoogleFonts.questrial(
      //                                       color: isDarkMode
      //                                           ? Colors.white54
      //                                           : Colors.black54,
      //                                       fontSize: size.height * 0.03,
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: EdgeInsets.only(
      //                                   top: size.height * 0.03,
      //                                   bottom: size.height * 0.01,
      //                                 ),
      //                                 child: Row(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.center,
      //                                   children: [
      //                                     Text(
      //                                       '$minTemp˚C', // min temperature
      //                                       style: GoogleFonts.questrial(
      //                                         color: minTemp <= 0
      //                                             ? Colors.blue
      //                                             : minTemp > 0 && minTemp <= 15
      //                                                 ? Colors.indigo
      //                                                 : minTemp > 15 &&
      //                                                         minTemp < 30
      //                                                     ? Colors.deepPurple
      //                                                     : Colors.green,
      //                                         fontSize: size.height * 0.03,
      //                                       ),
      //                                     ),
      //                                     Text(
      //                                       '/',
      //                                       style: GoogleFonts.questrial(
      //                                         color: isDarkMode
      //                                             ? Colors.white54
      //                                             : Colors.black54,
      //                                         fontSize: size.height * 0.03,
      //                                       ),
      //                                     ),
      //                                     Text(
      //                                       '$maxTemp˚C', //max temperature
      //                                       style: GoogleFonts.questrial(
      //                                         color: maxTemp <= 0
      //                                             ? Colors.blue
      //                                             : maxTemp > 0 && maxTemp <= 15
      //                                                 ? Colors.indigo
      //                                                 : maxTemp > 15 &&
      //                                                         maxTemp < 30
      //                                                     ? Colors.deepPurple
      //                                                     : Colors.green,
      //                                         fontSize: size.height * 0.03,
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: EdgeInsets.symmetric(
      //                                   horizontal: size.width * 0.05,
      //                                 ),
      //                                 child: Container(
      //                                   decoration: BoxDecoration(
      //                                     borderRadius: const BorderRadius.all(
      //                                       Radius.circular(10),
      //                                     ),
      //                                     color: isDarkMode
      //                                         ? Colors.white.withOpacity(0.05)
      //                                         : Colors.black.withOpacity(0.05),
      //                                   ),
      //                                   child: Column(
      //                                     children: [
      //                                       Align(
      //                                         alignment: Alignment.centerLeft,
      //                                         child: Padding(
      //                                           padding: EdgeInsets.only(
      //                                             top: size.height * 0.01,
      //                                             left: size.width * 0.03,
      //                                           ),
      //                                           child: Text(
      //                                             'Forecast for today',
      //                                             style: GoogleFonts.questrial(
      //                                               color: isDarkMode
      //                                                   ? Colors.white
      //                                                   : Colors.black,
      //                                               fontSize:
      //                                                   size.height * 0.025,
      //                                               fontWeight: FontWeight.bold,
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                       Padding(
      //                                         padding: EdgeInsets.all(
      //                                             size.width * 0.005),
      //                                         child: SingleChildScrollView(
      //                                           scrollDirection:
      //                                               Axis.horizontal,
      //                                           child: Row(
      //                                             children: weatherForecast.map((data) {
      //           return buildForecastToday(
      //             data.time,
      //             data.temperature,
      //             (data.windSpeed * 3.6).round(), // Convert m/s to km/h
      //             data.precipitation.toInt(),
      //             getWeatherIcon(data.condition),
      //             size,
      //             isDarkMode,
      //           );
      //         }).toList(),
      //                                             // children: [
      //                                             //   //TODO: change weather forecast from local to api get
      //                                             //   buildForecastToday(
      //                                             //     "Now", //hour
      //                                             //     currTemp, //temperature
      //                                             //     20, //wind (km/h)
      //                                             //     0, //rain chance (%)
      //                                             //     FontAwesomeIcons
      //                                             //         .sun, //weather icon
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "15:00",
      //                                             //     1,
      //                                             //     10,
      //                                             //     40,
      //                                             //     FontAwesomeIcons.cloud,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "16:00",
      //                                             //     0,
      //                                             //     25,
      //                                             //     80,
      //                                             //     FontAwesomeIcons
      //                                             //         .cloudRain,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "17:00",
      //                                             //     -2,
      //                                             //     28,
      //                                             //     60,
      //                                             //     FontAwesomeIcons
      //                                             //         .snowflake,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "18:00",
      //                                             //     -5,
      //                                             //     13,
      //                                             //     40,
      //                                             //     FontAwesomeIcons
      //                                             //         .cloudMoon,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "19:00",
      //                                             //     -8,
      //                                             //     9,
      //                                             //     60,
      //                                             //     FontAwesomeIcons
      //                                             //         .snowflake,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "20:00",
      //                                             //     -13,
      //                                             //     25,
      //                                             //     50,
      //                                             //     FontAwesomeIcons
      //                                             //         .snowflake,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "21:00",
      //                                             //     -14,
      //                                             //     12,
      //                                             //     40,
      //                                             //     FontAwesomeIcons
      //                                             //         .cloudMoon,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "22:00",
      //                                             //     -15,
      //                                             //     1,
      //                                             //     30,
      //                                             //     FontAwesomeIcons.moon,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             //   buildForecastToday(
      //                                             //     "23:00",
      //                                             //     -15,
      //                                             //     15,
      //                                             //     20,
      //                                             //     FontAwesomeIcons.moon,
      //                                             //     size,
      //                                             //     isDarkMode,
      //                                             //   ),
      //                                             // ],
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               ),
      //                               Padding(
      //                                 padding: EdgeInsets.symmetric(
      //                                   horizontal: size.width * 0.05,
      //                                   vertical: size.height * 0.02,
      //                                 ),
      //                                 child: Container(
      //                                   decoration: BoxDecoration(
      //                                     borderRadius: const BorderRadius.all(
      //                                       Radius.circular(10),
      //                                     ),
      //                                     color: Colors.white.withOpacity(0.05),
      //                                   ),
      //                                   child: Column(
      //                                     children: [
      //                                       Align(
      //                                         alignment: Alignment.centerLeft,
      //                                         child: Padding(
      //                                           padding: EdgeInsets.only(
      //                                             top: size.height * 0.02,
      //                                             left: size.width * 0.03,
      //                                           ),
      //                                           child: Text(
      //                                             '7-day forecast',
      //                                             style: GoogleFonts.questrial(
      //                                               color: isDarkMode
      //                                                   ? Colors.white
      //                                                   : Colors.black,
      //                                               fontSize:
      //                                                   size.height * 0.025,
      //                                               fontWeight: FontWeight.bold,
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ),
      //                                       Divider(
      //                                         color: isDarkMode
      //                                             ? Colors.white
      //                                             : Colors.black,
      //                                       ),
      //                                       Padding(
      //                                         padding: EdgeInsets.all(
      //                                             size.width * 0.005),
      //                                         child: Column(
      //                                           children: [
      //                                             //TODO: change weather forecast from local to api get
      //                                             buildSevenDayForecast(
      //                                               "Today", //day
      //                                               minTemp, //min temperature
      //                                               maxTemp, //max temperature
      //                                               FontAwesomeIcons
      //                                                   .cloud, //weather icon
      //                                               size,
      //                                               isDarkMode,
      //                                             ),
      //                                             buildSevenDayForecast(
      //                                               "Wed",
      //                                               -5,
      //                                               5,
      //                                               FontAwesomeIcons.sun,
      //                                               size,
      //                                               isDarkMode,
      //                                             ),
      //                                             buildSevenDayForecast(
      //                                               "Thu",
      //                                               -2,
      //                                               7,
      //                                               FontAwesomeIcons.cloudRain,
      //                                               size,
      //                                               isDarkMode,
      //                                             ),
      //                                             buildSevenDayForecast(
      //                                               "Fri",
      //                                               3,
      //                                               10,
      //                                               FontAwesomeIcons.sun,
      //                                               size,
      //                                               isDarkMode,
      //                                             ),
      //                                             buildSevenDayForecast(
      //                                               "San",
      //                                               5,
      //                                               12,
      //                                               FontAwesomeIcons.sun,
      //                                               size,
      //                                               isDarkMode,
      //                                             ),
      //                                             buildSevenDayForecast(
      //                                               "Sun",
      //                                               4,
      //                                               7,
      //                                               FontAwesomeIcons.cloud,
      //                                               size,
      //                                               isDarkMode,
      //                                             ),
      //                                             buildSevenDayForecast(
      //                                               "Mon",
      //                                               -2,
      //                                               1,
      //                                               FontAwesomeIcons.snowflake,
      //                                               size,
      //                                               isDarkMode,
      //                                             ),
      //                                             buildSevenDayForecast(
      //                                               "Tues",
      //                                               0,
      //                                               3,
      //                                               FontAwesomeIcons.cloudRain,
      //                                               size,
      //                                               isDarkMode,
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         );
      //       }
      //     },
      //   ),
      // ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/2.jpg"), // Change to your image path
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  // color: Colors.green,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(25),
                  //   bottomRight: Radius.circular(25),
                  // ),
                  ),
              child: ClipRRect(
                  // borderRadius: const BorderRadius.only(
                  //   bottomLeft: Radius.circular(25),
                  //   bottomRight: Radius.circular(25),
                  // ),
                  // child: Image.asset(
                  //   "assets/images/weather2.jpg",
                  //   fit: BoxFit.cover, // Ensures the image covers the container
                  // ),
                  ),
            ),
            Positioned(
              child: Center(
                child: Container(
                  height: size.height,
                  width: size.height,
                  decoration: BoxDecoration(
                      // color: isDarkMode ? Colors.black : Colors.white,
                      ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01,
                                  horizontal: size.width * 0.05,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // FaIcon(
                                    //   FontAwesomeIcons.bars,
                                    //   color: isDarkMode ? Colors.white : Colors.black,
                                    // ),
                                    Align(
                                      child: Text(
                                        'Weather', //TODO: change app name
                                        style: GoogleFonts.questrial(
                                          color: isDarkMode
                                              ? Colors.white
                                              : const Color(0xff1D1617),
                                          fontSize: size.height * 0.025,
                                        ),
                                      ),
                                    ),
                                    // FaIcon(
                                    //   FontAwesomeIcons.plusCircle,
                                    //   color: isDarkMode
                                    //       ? Colors.white
                                    //       : Colors.black,
                                    // ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    labelText: "Search city",
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        if (searchController.text.isNotEmpty) {
                                          fetchLatLon(searchController.text);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.03,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      cityName,
                                      style: GoogleFonts.questrial(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold,
                                        
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.005,
                                ),
                                child: Align(
                                  child: Text(
                                    'Today', //day
                                    style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.white54
                                          : Colors.black54,
                                      fontSize: size.height * 0.035,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.03,
                                ),
                                child: Align(
                                  child: Text(
                                    // '$currTemp˚C', //curent temperature
                                    firstDayWeather.isNotEmpty
                                        ? '${firstDayWeather.first.temperature}˚C'
                                        : '$currTemp˚C', //curent temperature
                                    style: GoogleFonts.questrial(
                                      color: currTemp <= 0
                                          ? Colors.blue
                                          : currTemp > 0 && currTemp <= 15
                                              ? Colors.indigo
                                              : currTemp > 15 && currTemp < 30
                                                  ? Colors.deepPurple
                                                  : Colors.green,
                                      fontSize: size.height * 0.11,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.25),
                                child: Divider(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.005,
                                ),
                                child: Align(
                                  child: Text(
                                    'Sunny', // weather
                                    style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.white54
                                          : Colors.black54,
                                      fontSize: size.height * 0.03,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.03,
                                  bottom: size.height * 0.01,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$minTemp˚C', // min temperature
                                      style: GoogleFonts.questrial(
                                        color: minTemp <= 0
                                            ? Colors.blue
                                            : minTemp > 0 && minTemp <= 15
                                                ? Colors.indigo
                                                : minTemp > 15 && minTemp < 30
                                                    ? Colors.deepPurple
                                                    : Colors.green,
                                        fontSize: size.height * 0.03,
                                      ),
                                    ),
                                    Text(
                                      '/',
                                      style: GoogleFonts.questrial(
                                        color: isDarkMode
                                            ? Colors.white54
                                            : Colors.black54,
                                        fontSize: size.height * 0.03,
                                      ),
                                    ),
                                    Text(
                                      '$maxTemp˚C', //max temperature
                                      style: GoogleFonts.questrial(
                                        color: maxTemp <= 0
                                            ? Colors.blue
                                            : maxTemp > 0 && maxTemp <= 15
                                                ? Colors.indigo
                                                : maxTemp > 15 && maxTemp < 30
                                                    ? Colors.deepPurple
                                                    : Colors.green,
                                        fontSize: size.height * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.05)
                                        : Colors.black.withOpacity(0.1),
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: size.height * 0.01,
                                            left: size.width * 0.03,
                                          ),
                                          child: Text(
                                            'Forecast for today',
                                            style: GoogleFonts.questrial(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: size.height * 0.025,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.005),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: firstDayWeather.map((data) {
                                              return buildForecastToday(
                                                data.time,
                                                data.temperature,
                                                (data.windSpeed * 3.6)
                                                    .round(), // Convert m/s to km/h
                                                data.precipitation.toInt(),
                                                getWeatherIcon(data.condition),
                                                size,
                                                isDarkMode,
                                              );
                                            }).toList(),
                                            // children: [
                                            //   //TODO: change weather forecast from local to api get
                                            //   buildForecastToday(
                                            //     "Now", //hour
                                            //     currTemp, //temperature
                                            //     20, //wind (km/h)
                                            //     0, //rain chance (%)
                                            //     FontAwesomeIcons
                                            //         .sun, //weather icon
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "15:00",
                                            //     1,
                                            //     10,
                                            //     40,
                                            //     FontAwesomeIcons.cloud,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "16:00",
                                            //     0,
                                            //     25,
                                            //     80,
                                            //     FontAwesomeIcons.cloudRain,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "17:00",
                                            //     -2,
                                            //     28,
                                            //     60,
                                            //     FontAwesomeIcons.snowflake,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "18:00",
                                            //     -5,
                                            //     13,
                                            //     40,
                                            //     FontAwesomeIcons.cloudMoon,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "19:00",
                                            //     -8,
                                            //     9,
                                            //     60,
                                            //     FontAwesomeIcons.snowflake,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "20:00",
                                            //     -13,
                                            //     25,
                                            //     50,
                                            //     FontAwesomeIcons.snowflake,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "21:00",
                                            //     -14,
                                            //     12,
                                            //     40,
                                            //     FontAwesomeIcons.cloudMoon,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "22:00",
                                            //     -15,
                                            //     1,
                                            //     30,
                                            //     FontAwesomeIcons.moon,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            //   buildForecastToday(
                                            //     "23:00",
                                            //     -15,
                                            //     15,
                                            //     20,
                                            //     FontAwesomeIcons.moon,
                                            //     size,
                                            //     isDarkMode,
                                            //   ),
                                            // ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                  vertical: size.height * 0.02,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: size.height * 0.02,
                                            left: size.width * 0.03,
                                          ),
                                          child: Text(
                                            '7-day forecast',
                                            style: GoogleFonts.questrial(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: size.height * 0.025,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(size.width * 0.005),
                                        child: Column(
                                          children:
                                              groupedWeather.entries.map((entry) {
                                            String date = entry.key;
                                            List<WeatherData> dailyData =
                                                entry.value;
        
                                            int minTemp = dailyData
                                                .map((e) => e.temperature)
                                                .reduce((a, b) => a < b ? a : b);
                                            int maxTemp = dailyData
                                                .map((e) => e.temperature)
                                                .reduce((a, b) => a > b ? a : b);
                                            String mostFrequentCondition =
                                                dailyData.first.condition;
                                            IconData weatherIcon = getWeatherIcon(
                                                mostFrequentCondition);
        
                                            return buildSevenDayForecast(
                                              formatDate(
                                                  date), // Convert "14-02-2025" -> "Friday"
                                              minTemp.round(),
                                              maxTemp.round(),
                                              weatherIcon,
                                              size,
                                              isDarkMode,
                                            );
                                          }).toList(),
                                          // children: [
                                          //   //TODO: change weather forecast from local to api get
                                          //   buildSevenDayForecast(
                                          //     "Today", //day
                                          //     minTemp, //min temperature
                                          //     maxTemp, //max temperature
                                          //     FontAwesomeIcons
                                          //         .cloud, //weather icon
                                          //     size,
                                          //     isDarkMode,
                                          //   ),
                                          //   buildSevenDayForecast(
                                          //     "Wed",
                                          //     -5,
                                          //     5,
                                          //     FontAwesomeIcons.sun,
                                          //     size,
                                          //     isDarkMode,
                                          //   ),
                                          //   buildSevenDayForecast(
                                          //     "Thu",
                                          //     -2,
                                          //     7,
                                          //     FontAwesomeIcons.cloudRain,
                                          //     size,
                                          //     isDarkMode,
                                          //   ),
                                          //   buildSevenDayForecast(
                                          //     "Fri",
                                          //     3,
                                          //     10,
                                          //     FontAwesomeIcons.sun,
                                          //     size,
                                          //     isDarkMode,
                                          //   ),
                                          //   buildSevenDayForecast(
                                          //     "San",
                                          //     5,
                                          //     12,
                                          //     FontAwesomeIcons.sun,
                                          //     size,
                                          //     isDarkMode,
                                          //   ),
                                          //   buildSevenDayForecast(
                                          //     "Sun",
                                          //     4,
                                          //     7,
                                          //     FontAwesomeIcons.cloud,
                                          //     size,
                                          //     isDarkMode,
                                          //   ),
                                          //   buildSevenDayForecast(
                                          //     "Mon",
                                          //     -2,
                                          //     1,
                                          //     FontAwesomeIcons.snowflake,
                                          //     size,
                                          //     isDarkMode,
                                          //   ),
                                          //   buildSevenDayForecast(
                                          //     "Tues",
                                          //     0,
                                          //     3,
                                          //     FontAwesomeIcons.cloudRain,
                                          //     size,
                                          //     isDarkMode,
                                          //   ),
                                          // ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildForecastToday(String time, int temp, int wind, int rainChance,
      IconData weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [
          Text(
            time,
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$temp˚C',
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.025,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.wind,
                  color: Colors.grey,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$wind km/h',
            style: GoogleFonts.questrial(
              color: Colors.grey,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.umbrella,
                  color: Colors.blue,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$rainChance %',
            style: GoogleFonts.questrial(
              color: Colors.blue,
              fontSize: size.height * 0.02,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSevenDayForecast(String time, int minTemp, int maxTemp,
      IconData weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  time,
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.black : Colors.black,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.black : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: Text(
                    '$minTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.black : Colors.black38,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    '$maxTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.black : Colors.black,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: isDarkMode ? Colors.black : Colors.black,
          ),
        ],
      ),
    );
  }
}

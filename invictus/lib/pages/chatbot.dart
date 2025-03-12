import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// class Chatbot extends StatefulWidget {
//   const Chatbot({super.key});

//   @override
//   State<Chatbot> createState() => _ChatbotState();
// }

// class _ChatbotState extends State<Chatbot> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1E1F25),

//     );
//   }
// }

import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:invictus/main.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chatbot extends StatefulWidget {
  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final List<Map<String, dynamic>> messages = [];
  final ScrollController _scrollController = ScrollController(); // ✅ Added
  bool _isLoading = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "";
  bool _isCropPlan = false; // Toggle for Crop Plan mode
  final picker = ImagePicker();
  AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _textController = TextEditingController();

  final String chatbotApiUrl = "http://192.168.137.1:8000/chatbot/";
  final String cropPlanApiUrl = "http://192.168.137.1:8000/cropplan/";

  void _startListening() async {
    // await requestPermissions();
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            print("Recognized Words: $_text"); // ✅ Debugging log
          });
        },
        listenFor: Duration(seconds: 5), // Set timeout
        cancelOnError: true,
        listenMode:
            stt.ListenMode.dictation, // Better accuracy for full sentences
      );
    } else {
      print("Speech recognition not available");
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
    if (_text.isNotEmpty) {
      _sendMessage(_text, true);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => messages.add({
            'type': MessageType.image,
            'content': pickedFile.path,
            'isUser': true
          }));
    }
  }

  void _playAudio(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String input, bool isUser) async {
    setState(() {
      messages
          .add({'type': MessageType.text, 'content': input, 'isUser': isUser});
      _isLoading = true; // ✅ Show loading
    });
    _scrollToBottom(); // ✅ Scroll to the bottom when new message arrives
    _textController.clear();

    if (isUser) {
      String apiUrl = _isCropPlan ? cropPlanApiUrl : chatbotApiUrl;
      try {
        String jsonBody = jsonEncode({"text": input});

        print("Sending JSON: $jsonBody"); // ✅ Debugging JSON format
        // final response = await http.post(
        //   Uri.parse(apiUrl),
        //   headers: {
        //     "Content-Type": "application/json",
        //     "Accept": "application/json",
        //   },
        //   // body: jsonEncode({"text": text}),
        //   body: jsonBody,
        // );

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          // body: jsonEncode({"text": input}),
          body: _isCropPlan ? jsonEncode({"text": input}) : jsonEncode({"language": 'en', "user_input": input}),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print("responseData:: $responseData");
          setState(() {
            messages.add({
              'type': MessageType.text,
              'content': responseData['response'],
              'isUser': false
            });
            _isLoading = false; // ✅ Hide loading
          });
          _scrollToBottom(); // ✅ Scroll to the bottom when new message arrives
        }
      } catch (e) {
        print("Error sending message: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();

    // requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "KrishiMitra",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      // backgroundColor: Color(0xFF1E1F25),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            // height: queryData.size.height,
            width: queryData.size.width,
            child: Image.asset(
              "assets/images/chatbot.jpg",
              fit: BoxFit.cover, // Ensures the image covers the container
            ),
          ),
          Column(
            children: [
              // Toggle button for Crop Plan mode
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Generate Crop Plan",
                        style: TextStyle(color: Colors.white)),
                    Switch(
                      value: _isCropPlan,
                      onChanged: (value) {
                        setState(() {
                          _isCropPlan = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // ✅ Attach controller
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    bool isUser =
                        message['isUser'] ?? false; // Default to false if null
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: message['type'] == MessageType.text
                            ? Text(
                                message['content'],
                                style: TextStyle(
                                    color:
                                        isUser ? Colors.white : Colors.black),
                              )
                            : message['type'] == MessageType.image
                                ? Image.asset(message['content'])
                                : IconButton(
                                    icon: Icon(Icons.play_arrow,
                                        color: Colors.white),
                                    onPressed: () =>
                                        _playAudio(message['content']),
                                  ),
                      ),
                    );
                  },
                ),
              ),
              if (_isLoading)
                SpinKitThreeBounce(
                  color: Colors.greenAccent,
                  size: 30.0,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.mic,
                          color: _isListening ? Colors.red : Colors.white),
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.image, color: Colors.white),
                    //   onPressed: _pickImage,
                    // ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green, // Change to your desired color
                      ),
                      padding: EdgeInsets.all(4), //
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.black),
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            _sendMessage(_textController.text, true);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum MessageType { text, image, audio }

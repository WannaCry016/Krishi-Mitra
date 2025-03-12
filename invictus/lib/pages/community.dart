// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:intl/intl.dart';

// // // class Community extends StatefulWidget {
// // //   const Community({super.key});

// // //   @override
// // //   State<Community> createState() => _CommunityState();
// // // }

// // // class _CommunityState extends State<Community> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold();
// // //   }
// // // }

// // class Community extends StatefulWidget {
// //   @override
// //   _CommunityState createState() => _CommunityState();
// // }

// // class _CommunityState extends State<Community> {
// //   final TextEditingController _controller = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();

// //   void _sendMessage() {
// //     if (_controller.text.trim().isEmpty) return;

// //     FirebaseFirestore.instance.collection('messages').add({
// //       'text': _controller.text.trim(),
// //       'timestamp': FieldValue.serverTimestamp(),
// //       'sender': 'Anonymous Farmer',
// //     });

// //     _controller.clear();
// //     Future.delayed(Duration(milliseconds: 300), () {
// //       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color(0xFF1E1F25),
// //       // appBar: AppBar(
// //       //   title: Text(
// //       //     "Farmers Chatroom",
// //       //     style: TextStyle(
// //       //       color: Colors.white
// //       //     ),
// //       //     ),
// //       // backgroundColor: Color(0xFF1E1F25),

// //       //   ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: StreamBuilder(
// //               stream: FirebaseFirestore.instance
// //                   .collection('messages')
// //                   .orderBy('timestamp', descending: false)
// //                   .snapshots(),
// //               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

// //                 return ListView(
// //                   controller: _scrollController,
// //                   children: snapshot.data!.docs.map((doc) {
// //                     return ChatBubble(
// //                       text: doc['text'],
// //                       sender: doc['sender'],
// //                       timestamp: doc['timestamp']?.toDate() ?? DateTime.now(),
// //                     );
// //                   }).toList(),
// //                 );
// //               },
// //             ),
// //           ),
// //           _buildMessageInput(),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildMessageInput() {
// //     return Container(
// //       padding: EdgeInsets.all(10),
// //       color: Colors.black54,
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: TextField(

// //               controller: _controller,
// //               decoration: InputDecoration(
// //                 hintText: "Type your message...",
// //                 fillColor: Colors.white,
// //                 border: InputBorder.none,
// //               ),
// //               onSubmitted: (_) => _sendMessage(),
// //             ),
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.send, color: Colors.green),
// //             onPressed: _sendMessage,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class ChatBubble extends StatelessWidget {
// //   final String text;
// //   final String sender;
// //   final DateTime timestamp;

// //   const ChatBubble({
// //     required this.text,
// //     required this.sender,
// //     required this.timestamp,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(sender, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
// //           Container(
// //             margin: EdgeInsets.only(top: 3),
// //             padding: EdgeInsets.all(12),
// //             decoration: BoxDecoration(
// //               color: Colors.deepPurpleAccent,
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(text, style: TextStyle(fontSize: 16)),
// //                 SizedBox(height: 5),
// //                 Text(
// //                   DateFormat('hh:mm a').format(timestamp),
// //                   style: TextStyle(fontSize: 12, color: Colors.white60),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_core/firebase_core.dart';

// class Community extends StatefulWidget {
//   @override
//   _CommunityState createState() => _CommunityState();
// }

// class _CommunityState extends State<Community> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   void _sendMessage() {
//     if (_controller.text.trim().isEmpty) return;

//     FirebaseFirestore.instance.collection('messages').add({
//       'text': _controller.text.trim(),
//       'timestamp': FieldValue.serverTimestamp(),
//       'sender': 'Anonymous Farmer',
//     });

//     _controller.clear();

//     // Ensure it scrolls to the latest message
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: const Color(0xFF1E1F25),
//       backgroundColor: Colors.green[100],
//       appBar: AppBar(
//         title: Text("Farmers Chatroom", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('messages')
//                   .orderBy('timestamp', descending: false)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final messages = snapshot.data!.docs;

//                 if (messages.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No messages yet. Start the conversation!",
//                       style: TextStyle(color: Colors.white54),
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   controller: _scrollController,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final DocumentSnapshot doc = messages[index];

//                     return ChatBubble(
//                       text: doc['text'],
//                       sender: doc['sender'],
//                       timestamp: (doc['timestamp'] as Timestamp?)?.toDate() ??
//                           DateTime.now(),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 30, 39, 44), // Background color of the input field
//           borderRadius: BorderRadius.circular(25), // Rounded corners
//           // border: Border.all(color: Colors.white54), // Optional: Border color
//         ),
//         padding: const EdgeInsets.all(10),
//         // color: Colors.black54,
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 style: TextStyle(color: Colors.white),
//                 controller: _controller,
//                 decoration: const InputDecoration(
//                   hintText: "Type your message...",
//                   hintStyle: TextStyle(color: Colors.grey),
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (_) => _sendMessage(),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.send, color: Colors.green),
//               onPressed: _sendMessage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String text;
//   final String sender;
//   final DateTime timestamp;

//   const ChatBubble({
//     required this.text,
//     required this.sender,
//     required this.timestamp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 3),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 35, 38, 55),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   sender,
//                   style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green),
//                 ),
//                 Text(text,
//                     style: const TextStyle(fontSize: 16, color: Colors.white)),
//                 const SizedBox(height: 5),
//                 Text(
//                   DateFormat('hh:mm a').format(timestamp),
//                   style: const TextStyle(fontSize: 12, color: Colors.white60),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_core/firebase_core.dart';

// class Community extends StatefulWidget {
//   @override
//   _CommunityState createState() => _CommunityState();
// }

// class _CommunityState extends State<Community> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   String selectedChannel = "General"; // Default channel
//   List<String> channels = ["General", "Organic Farming", "Crop Diseases", "Weather Alerts"];

//   void _sendMessage() {
//     if (_controller.text.trim().isEmpty) return;


//     FirebaseFirestore.instance
//         .collection('channels')
//         .doc(selectedChannel)
//         .collection('messages')
//         .add({
//       'text': _controller.text.trim(),
//       'timestamp': FieldValue.serverTimestamp(),
//       'sender': 'Anonymous Farmer',
//     });

//     _controller.clear();

//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green[100],
//       appBar: AppBar(
//         title: Text("Farmers Chatroom", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           _buildChannelSelector(),
//           Expanded(child: _buildMessageStream()),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildChannelSelector() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       color: Colors.white,
//       child: DropdownButton<String>(
//         value: selectedChannel,
//         icon: Icon(Icons.arrow_drop_down, color: Colors.black),
//         isExpanded: true,
//         style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Poppins-Regular"),
//         underline: Container(height: 2, color: Colors.green),
//         items: channels.map((channel) {
//           return DropdownMenuItem(
//             value: channel,
//             child: Text(channel),
//           );
//         }).toList(),
//         onChanged: (value) {
//           setState(() {
//             selectedChannel = value!;
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildMessageStream() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('channels')
//           .doc(selectedChannel)
//           .collection('messages')
//           .orderBy('timestamp', descending: false)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: Text("Loading messages...", style: TextStyle(color: Colors.black54)));
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.red)));
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Text(
//               "No messages yet. Start the conversation!",
//               style: TextStyle(color: Colors.black54),
//             ),
//           );
//         }

//         final messages = snapshot.data!.docs;

//         return ListView.builder(
//           controller: _scrollController,
//           itemCount: messages.length,
//           itemBuilder: (context, index) {
//             final DocumentSnapshot doc = messages[index];

//             return ChatBubble(
//               text: doc['text'],
//               sender: doc['sender'],
//               timestamp: (doc['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 30, 39, 44),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 style: TextStyle(color: Colors.white),
//                 controller: _controller,
//                 decoration: const InputDecoration(
//                   hintText: "Type your message...",
//                   hintStyle: TextStyle(color: Colors.grey),
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (_) => _sendMessage(),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.send, color: Colors.green),
//               onPressed: _sendMessage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String text;
//   final String sender;
//   final DateTime timestamp;

//   const ChatBubble({
//     required this.text,
//     required this.sender,
//     required this.timestamp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 3),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 35, 38, 55),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   sender,
//                   style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green),
//                 ),
//                 Text(text,
//                     style: const TextStyle(fontSize: 16, color: Colors.white)),
//                 const SizedBox(height: 5),
//                 Text(
//                   DateFormat('hh:mm a').format(timestamp),
//                   style: const TextStyle(fontSize: 12, color: Colors.white60),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Community extends StatefulWidget {
  final User? user;
  Community({required this.user});

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String selectedChannel = "General";
  List<String> channels = ["General", "Organic Farming", "Crop Diseases", "Weather Alerts"];
  String username = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
  DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(widget.user!.uid);

  DocumentSnapshot userDoc = await userDocRef.get();

  if (userDoc.exists && userDoc.data() != null) {
    setState(() {
      username = userDoc['username'];
    });
  } else {
    // Generate a username if not found
    String generatedUsername = widget.user!.email!.split('@')[0];

    await userDocRef.set({
      'username': generatedUsername,
      'email': widget.user!.email,
    });

    setState(() {
      username = generatedUsername;
    });
  }
}


  void _sendMessage() async {
  if (_controller.text.trim().isEmpty) return;

  if (username == "Loading...") {
    await _fetchUsername();
  }

  FirebaseFirestore.instance
      .collection('channels')
      .doc(selectedChannel)
      .collection('messages')
      .add({
    'text': _controller.text.trim(),
    'timestamp': FieldValue.serverTimestamp(),
    'sender': username,
  });

  _controller.clear();

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Text(selectedChannel, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      body: Container(
         decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/community.jpg"), // Change to your image path
            fit: BoxFit.cover, // Ensures the image covers the entire background
          ),
        ),
        child: Column(
          children: [
            Expanded(child: _buildMessageStream()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      // width: 250,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Text(
                "Channels",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.chat, color: selectedChannel == channels[index] ? Colors.black : Colors.black54),
                  title: Text(
                    channels[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedChannel == channels[index] ? Colors.green : Colors.black,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedChannel = channels[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('channels')
          .doc(selectedChannel)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text("Loading messages...", style: TextStyle(color: Colors.white)));
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.red)));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No messages yet. Start the conversation!", style: TextStyle(color: Colors.white)),
          );
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final doc = messages[index];

            return _buildChatBubble(doc['text'], doc['sender'],
                (doc['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now());
          },
        );
      },
    );
  }

  Widget _buildChatBubble(String text, String sender, DateTime timestamp) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Align(
        alignment: sender == username ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: sender == username ? Colors.green[300] : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sender, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(height: 5),
              Text(text, style: TextStyle(fontSize: 16)),
              SizedBox(height: 5),
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
  }

  // Widget _buildMessageInput() {
  //   return Padding(
  //     padding: EdgeInsets.all(8),
  //     child: Row(
  //       children: [
  //         Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: "Type a message..."))),
  //         IconButton(icon: Icon(Icons.send, color: Colors.black), onPressed: _sendMessage),
  //       ],
  //     ),
  //   );
  // }

    Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 30, 39, 44),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Type your message...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.green),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
// }

}

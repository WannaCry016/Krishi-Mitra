import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Post extends StatelessWidget {
  final String profileImage;
  final String username;
  final String postImage;
  final int likes;
  final String caption;
  final String description;
  final String link;

  const Post({
    Key? key,
    required this.profileImage,
    required this.username,
    required this.postImage,
    required this.likes,
    required this.caption,
    required this.description,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(25),
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      profileImage,
                    ),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  )
                ],
              ),
            ),

            // Post Image
            // CachedNetworkImage(
            //   imageUrl: postImage,
            //   useOldImageOnUrlChange: true,
            //   placeholder: (context, url) => Container(
            //     height: 300,
            //     color: Colors.grey[300],
            //   ),
            //   errorWidget: (context, url, error) => const Icon(Icons.error),
            //   fit: BoxFit.cover,
            //   width: double.infinity,
            //   height: 300,
            // ),
            SizedBox(
                height: 300,
                child: Image.network(
                  postImage,
                  fit: BoxFit.cover,
                )),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.chat_bubble_outline),
                  //   onPressed: () {},
                  // ),
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () {
                      _launchURL(link);
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Likes
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Text('$likes likes', style: const TextStyle(fontWeight: FontWeight.bold)),
            // ),

            // Caption
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins-Regular"),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                        text: caption,
                        style: TextStyle(fontFamily: "Poppins-Regular")),
                  ],
                ),
              ),
            ),

            // Time Ago
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchURL(url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

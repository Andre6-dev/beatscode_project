import 'package:beatscode_project/utils/colors.dart';
import 'package:beatscode_project/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*Main Bar who shows the logo and the icon in the edge of the screen.*/
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image(
          image: AssetImage('assets/logo_feed.png'),
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              LineIcons.phoenixFramework,
              color: Colors.white,
              size: 35,
            ),
          )
        ],
      ),

      /*We need Stream Builder because we need to listen the upcoming posts
      * in real time */
      body: StreamBuilder(
        /*Our stream builder works based in your stream*/
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          /*Creates a scrollable, linear array of widgets that are created on demand,
          * so we need the length and what we are going to render(PostCards)*/
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              snap: snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
    );
  }
}

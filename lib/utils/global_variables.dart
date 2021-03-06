import 'package:beatscode_project/screens/add_post_screen.dart';
import 'package:beatscode_project/screens/feed_screen.dart';
import 'package:beatscode_project/screens/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  /*Adding FeedScreen who is the initial view*/
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('music'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

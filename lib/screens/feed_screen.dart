import 'package:beatscode_project/utils/colors.dart';
import 'package:beatscode_project/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*Main Bar who shows the logo and the icon in the edge of the screen.*/
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.messenger_outline,
            ),
          )
        ],
      ),
      body: PostCard(),
    );
  }
}

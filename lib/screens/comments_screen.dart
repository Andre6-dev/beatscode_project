import 'package:beatscode_project/resources/firestore_methods.dart';
import 'package:beatscode_project/utils/colors.dart';
import 'package:beatscode_project/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:beatscode_project/models/user.dart' as model;
import 'package:beatscode_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    return user == null
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text('Comments'),
              centerTitle: false,
            ),

            /*COMMENTS*/
            body: CommentCard(),

            /*COMMENT ZONE*/
            bottomNavigationBar: SafeArea(
              child: Container(
                height: kToolbarHeight,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                padding: const EdgeInsets.only(left: 16, right: 8),

                // COMMENT SECTION
                /*This part defines the row which contains the avatar, textfield and
          * button to post a comment. */
                child: Row(
                  children: [
                    /*AVATAR*/
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://images.squarespace-cdn.com/content/v1/51b3dc8ee4b051b96ceb10de/1401467111255-TM3V8CHFU2O92OGASHQO/tumblr_n6adpeNPvI1qg8i80o3_1280.jpg',
                      ),
                      radius: 18,
                    ),
                    /*TEXTFIELD*/
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8.0),
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Comment as username',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    /*BUTTON*/
                    InkWell(
                      onTap: () async {
                        await FirestoreMethods().postComment(
                          widget.snap['postId'],
                          _commentController.text,
                          user.uid,
                          user.username,
                          user.photoUrl,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

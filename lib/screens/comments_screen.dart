import 'package:beatscode_project/resources/firestore_methods.dart';
import 'package:beatscode_project/utils/colors.dart';
import 'package:beatscode_project/widgets/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            /*We have a Stream builder because we need to have our comments throughout a stream*/
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .collection('comments')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => CommentCard(
                      snap: (snapshot.data! as dynamic).docs[index].data()),
                );
              }, // Load comments from Firestore
            ),

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
                        user.photoUrl,
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
                            hintText: 'Comment as ${user.username}',
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

                        /*Clear the text field after the button is pressed.*/
                        setState(() {
                          _commentController.text = "";
                        });
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

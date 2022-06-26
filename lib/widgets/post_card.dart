import 'package:beatscode_project/models/user.dart' as model;
import 'package:beatscode_project/providers/user_provider.dart';
import 'package:beatscode_project/resources/firestore_methods.dart';
import 'package:beatscode_project/screens/comments_screen.dart';
import 'package:beatscode_project/utils/colors.dart';
import 'package:beatscode_project/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:beatscode_project/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  /*Adding the argument snap to render every post that we have*/
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    /*Fixing error related with null value located in user provider*/
    return user == null
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Container(
            color: mobileBackgroundColor,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              children: [
                /* This container have the photo, username and the three dots symbol
          who are in the top of the feed*/
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ).copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          /*Showing our image from Firebase using snapshot*/
                          widget.snap['profImage'],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                /*Passing the username from Firebase*/
                                widget.snap['username'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shrinkWrap: true,
                                children: [
                                  'Delete',
                                ]
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          FirestoreMethods().deletePost(
                                            widget.snap['postId'],
                                            widget.snap['postUrl'],
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),

                /* SizedBox is a simple box with a specified size, this widget allow us
          to have our post image below the username*/
                /*We need to create a stack because we need the animation in the top
          * of the photo*/
                GestureDetector(
                  /*This part takes the likePost method and add a like to our
            collections through the likes field*/
                  onDoubleTap: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      /*Controlls the opacity of the hearth in the picture*/
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating
                            ? 1
                            : 0, // it controls the opacity when you tapped the photo
                        child: LikeAnimation(
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 120,
                          ),
                          isAnimating: isLikeAnimating,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          /*This option provide us that when the animation have been
                    * completed it should disappear*/
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),

                // LIKE COMMENT SECTION
                /*The row contains like, comment, share and bookmark icons;
          these icons are located below the main photo.*/
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.snap['likes'].contains(user.uid),
                      smallLike: true,
                      child: IconButton(
                        /*This method add or remove uid inside likes array, so when
                  * you pressed the like button this operation is going to start*/
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                            widget.snap['postId'],
                            user.uid,
                            widget.snap['likes'],
                          );
                          setState(() {
                            isLikeAnimating = true;
                          });
                        },
                        /*If the array have one element will be red, otherwise it will
                  * be grey */
                        icon: widget.snap['likes'].contains(user.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),

                /*The Container contains the username and the feeds name */
                // DESCRIPTION AND NUMBER OF COMMENTS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                        child: Text(
                          '${widget.snap['likes'].length} likes',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' ${widget.snap['description']}',
                              ),
                            ],
                          ),
                        ),
                      ),

                      /*Comments*/
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'View all $commentLen comments',
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ),

                      /*The publication date of my post */
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          /*Using intl to format Date*/
                          DateFormat.yMMMd().format(
                            widget.snap['datePublished'].toDate(),
                          ),
                          style: TextStyle(
                            fontSize: 11,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

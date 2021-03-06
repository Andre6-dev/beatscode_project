import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:beatscode_project/resources/firestore_methods.dart';
import 'package:beatscode_project/utils/colors.dart';
import 'package:beatscode_project/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );

      if (res == "success") {
        print("Hola");
        setState(() {
          _isLoading = false;
        });
        var snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message: 'Your image has been upload successfully!',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        print("Hola desde else");
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            backgroundColor: mobileBackgroundColor,
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop(); // remove the dialog box
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop(); // remove the dialog box
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop(); // remove the dialog box
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : _file == null
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.5,
                      0.8,
                      1,
                    ],
                    colors: [
                      Color(0xFF0A0A1E),
                      Color(0xFF16399E),
                      Color(0xFFB63FCA),
                    ],
                  )),
                  child: Center(
                    child: IconButton(
                      iconSize: 45,
                      icon: const Icon(LineIcons.alternateCloudUpload),
                      onPressed: () => _selectImage(context),
                    ),
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: clearImage,
                  ),
                  title: const Text('Post to'),
                  centerTitle: false,
                  actions: [
                    TextButton(
                      onPressed: () => postImage(
                        user.uid,
                        user.username,
                        user.photoUrl,
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    _isLoading
                        ? LiquidLinearProgressIndicator(
                            value: 0.25,
                            valueColor: AlwaysStoppedAnimation(Colors.pink),
                            backgroundColor: Colors.white,
                            borderColor: Colors.red,
                            borderWidth: 5.0,
                            borderRadius: 12.0,
                            direction: Axis.vertical,
                            center: Text("Loading..."),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 0),
                          ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceAround, // Espacio horizontal entre elementos pero el primero tiene mas espacio y tambien el ultimo
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Empieza de arriba hacia abajo
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            user.photoUrl,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              hintText: 'Write a caption...',
                              border: InputBorder.none,
                            ),
                            maxLines: 8,
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_app/model/post_model.dart';
import 'package:flutter_post_app/services/file_convert.dart';
import 'package:flutter_post_app/services/fire_service.dart';
import 'package:flutter_post_app/services/pick_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  File? image;
  late Pick? pickService;
  String? name = '';
  bool? isEnabled = false;
  bool? isLoading = false;
  var usernameController = TextEditingController();
  var titleController = TextEditingController();
  @override
  void initState() {
    pickService = Pick();
    super.initState();
  }

  void pickImage({required ImageSource source}) async {
    try {
      late final XFile? xfile;
      if (source == ImageSource.gallery) {
        xfile = await pickService!.getImageFromGallery();
        name = xfile!.name;
        setState(() {});
      } else if (source == ImageSource.camera) {
        xfile = await pickService!.getImageFromCamera();
        name = xfile!.name;
        setState(() {});
      }
      assert(xfile != null);
      image = FileConvert.convertFileFromXFile(xfile!);

      setState(() {
        Navigator.of(context).pop();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void publish() async {
    isEnabled = false;
    isLoading = true;
    setState(() {});
    try {
      final id = const Uuid().v1();
      PostModel post = PostModel(
        id: id,
        publishedDate: DateTime.now().toString(),
        username: usernameController.text,
        title: titleController.text,
      );

      final isPublished = await FireService.createPost(
          post: post, image: image, imageName: name);

      if (isPublished!) {
        debugPrint('PUBLISHED');
        isLoading = false;
        setState(() {
          Navigator.of(context).pop();
        });
      }
      debugPrint('PUBLISHED');
    } catch (e) {
      log(e.toString());
    }
  }

  void show() {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('select image source'),
              content:
                  const Text('you could select image from camera or gallery'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('camera'),
                  onPressed: () => pickImage(source: ImageSource.camera),
                ),
                CupertinoDialogAction(
                  child: const Text('gallery'),
                  onPressed: () => pickImage(source: ImageSource.gallery),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('creat post'),
      ),
      body: Builder(builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: show,
                child: image != null
                    ? Ink.image(
                        width: 200,
                        height: 200,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: FileImage(
                          image!,
                        ))
                    : Ink.image(
                        width: 200,
                        height: 200,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: const NetworkImage(
                            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80')),
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoTextField(
                controller: usernameController,
                placeholder: 'username',
                onChanged: (value) {
                  if (value.isNotEmpty &&
                      image != null &&
                      titleController.text.isNotEmpty) {
                    isEnabled = true;
                    setState(() {});
                  } else {
                    isEnabled = false;
                    setState(() {});
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoTextField(
                controller: titleController,
                placeholder: 'title',
                onChanged: (value) {
                  if (value.isNotEmpty &&
                      image != null &&
                      usernameController.text.isNotEmpty) {
                    isEnabled = true;
                    setState(() {});
                  } else {
                    isEnabled = false;
                    setState(() {});
                  }
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled! ? Colors.blue : Colors.grey),
                  onPressed: isEnabled! ? publish : () {},
                  child: isLoading!
                      ? const CupertinoActivityIndicator()
                      : const Text('publish'))
            ],
          ),
        );
      }),
    );
  }
}

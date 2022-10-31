import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_app/model/post_model.dart';
import 'package:flutter_post_app/page/create_post/create_post_view.dart';
import 'package:flutter_post_app/services/fire_service.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:intl/intl.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool? isLoading = false;
  Future<void> deletePost(PostModel? post) async {
    try {
      final isDeleted = await FireService.deletePostById(postModel: post);
      if (isDeleted!) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${post!.title} deleted'),
        ));
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('posts'),
      ),
      body: isLoading!
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : FirestoreListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              query: FireService.database
                  .collection('posts')
                  .orderBy('publishedDate', descending: true),
              loadingBuilder: (context) => const CupertinoActivityIndicator(),
              itemBuilder: (context, doc) {
                if (!doc.exists) {
                  return const Center(
                    child: Text('document not exists'),
                  );
                }

                PostModel post = PostModel.fromJson(doc.data());

                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        isThreeLine: false,
                        title: Text(post.username ?? 'user'),
                        subtitle: Text(post.title ?? 'title'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            isLoading = true;
                            setState(() {});
                            await deletePost(post);
                            isLoading = false;
                            setState(() {});
                          },
                        ),
                      ),
                      Image.network(
                        post.imageUrl ??
                            'https://www.statusw.com/public/images/imgeStatus.jpg',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      Text(DateFormat.MMMEd().format(
                          DateTime.tryParse(post.publishedDate!) ??
                              DateTime.now()))
                    ],
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const CreatePost()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_post_app/page/post/post_view.dart';
import 'package:flutter_post_app/services/app_setup.dart';

void main() async {
  await AppSetup.setup;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PostView(),
    );
  }
}

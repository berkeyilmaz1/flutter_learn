import 'package:flutter/material.dart';
import 'package:flutter_image_picker/feature/image_upload/view/home_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Image Picker',
        home: HomeView());
  }
}

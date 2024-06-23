import 'package:flutter/material.dart';
import 'package:flutter_image_picker/feature/image_upload/viewModel/image_upload_view_model.dart';
import 'package:flutter_image_picker/product/utility/image_upload.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _imageUploadViewModel = ImageUploadViewModel();
  final _imageUploadManager = ImageUploadManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _saveDataFabButton(),
      appBar: _appBar(),
      body: Column(
        children: [
          _imagePickButton(context),
          const Divider(),
          _imageShower(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text("Image Upload"),
      actions: [
        _progressIndicator(),
        _textProgress()
      ],
    );
  }

  FloatingActionButton _saveDataFabButton() {
    return FloatingActionButton(
      onPressed: () {
        _imageUploadViewModel.saveDatatoService();
      },
      child: const Icon(Icons.save),
    );
  }

  Observer _textProgress() {
    return Observer(
          builder: (context) {
            return Text(_imageUploadViewModel.downloadText);
          },
        );
  }

  Observer _progressIndicator() {
    return Observer(
          builder: (context) {
            return _imageUploadViewModel.isloading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          },
        );
  }

  Expanded _imagePickButton(BuildContext context) {
    return Expanded(
            child: Card(
          elevation: 10,
          child: FittedBox(
            child: IconButton(
                iconSize: 24,
                onPressed: () async {
                  _bottomSheet(context);
                },
                icon: LottieBuilder.asset("assets/lottie/image_picker.json")),
          ),
        ));
  }

  Expanded _imageShower() {
    return Expanded(
          flex: 3,
          child: Expanded(
            child: Observer(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: _imageUploadViewModel.file != null
                      ? Image.file(_imageUploadViewModel.file!)
                      : const Center(child: Text("No image selected")),
                );
              },
            ),
          ),
        );
  }

  Future<dynamic> _bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          _imageUploadViewModel.saveLocalFile(
                              await _imageUploadManager.fetchFromGalery());
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.photo)),
                    ElevatedButton(
                        onPressed: () async {
                          _imageUploadViewModel.saveLocalFile(
                              await _imageUploadManager.fetchFromCamera());
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.camera_alt_rounded)),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.navigate_before)),
              ],
            ),
          );
        });
  }
}

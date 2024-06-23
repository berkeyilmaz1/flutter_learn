import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_picker/feature/image_upload/model/image_response_model.dart';
import 'package:flutter_image_picker/feature/image_upload/service/image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'image_upload_view_model.g.dart';

class ImageUploadViewModel = _ImageUploadViewModelBase
    with _$ImageUploadViewModel;

abstract class _ImageUploadViewModelBase with Store {
  static const String _baseUrl =
      'https://firebasestorage.googleapis.com/v0/b/fluttertr-ead5c.appspot.com/o/';

  final ImageUploadService _imageUploadService =
      ImageUploadService(Dio(BaseOptions(baseUrl: _baseUrl)));

  @observable
  String downloadText = "";
  @observable
  String imageUrl = '';

  @observable
  File? file;
  @observable
  bool isloading = false;

  @action
  void updateDownloadText(int sent, int total) {
    downloadText = "$sent / $total ";
  }

  @action
  void uploadImageUrl(ImagePostModel? response) {
    if (response == null) return;
    imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/fluttertr-ead5c.appspot.com/o/${response.name?.replaceFirst('/', '%2F') ?? ''}';
  }

  @action
  void changeLoading() {
    isloading = !isloading;
  }

  @action
  void saveLocalFile(XFile? file) {
    if (file == null) return;
    this.file = File(file.path);
  }

  Future<void> saveDatatoService() async {
    if (file == null) return;
    changeLoading();
    final response = await _imageUploadService.uploadImageToService(
      await file!.readAsBytes(),
      'berkeyz',
      onSendProgress: (sent, total) {
        updateDownloadText(sent, total);
      },
    );
    uploadImageUrl(response);
    changeLoading();
  }
}

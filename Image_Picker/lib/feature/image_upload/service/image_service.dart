import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_image_picker/feature/image_upload/model/image_response_model.dart';

class ImageUploadService {
  final Dio _dio;

  ImageUploadService(this._dio);

  Future<ImagePostModel?> uploadImageToService(Uint8List byteArray, String name,
      {void Function(int, int)? onSendProgress}) async {
    final response = await _dio.post('full%2F$name.png',
        data: byteArray, onSendProgress: onSendProgress);
    if (response.statusCode == HttpStatus.ok) {
      return ImagePostModel.fromJson(response.data);
    }
    return null;
  }
}

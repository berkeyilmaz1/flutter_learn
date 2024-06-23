import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadManager {
  final ImagePicker picker = ImagePicker();
  Future<XFile?> cropImage(XFile file) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: file.path);
    if (croppedImage == null) return null;
    return XFile(croppedImage.path);
  }

  Future<XFile?> fetchFromGalery() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    image = await cropImage(image);
    return image;
  }

  Future<XFile?> fetchFromCamera() async {
    XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return null;
    photo = await cropImage(photo);
    return photo;
  }
}

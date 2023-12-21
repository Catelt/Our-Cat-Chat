import 'package:image_picker/image_picker.dart';

class XImagePicker {
  factory XImagePicker() => instance;
  XImagePicker._internal();

  static final XImagePicker instance = XImagePicker._internal();

  final ImagePicker _picker = ImagePicker();

  Future<String?> selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    return pickedFile?.path;
  }
}

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class CustomImageModel {
  String name;
  Uint8List? bytes;
  int size;
  String? extension;
  String path;
  bool isLocalImage;

  CustomImageModel({
    required this.name,
    required this.bytes,
    required this.size,
    required this.extension,
    required this.path,
    required this.isLocalImage,
  });

  factory CustomImageModel.fromPlatFormFile(PlatformFile file, bool isLocalImage) => CustomImageModel(
    name: file.name,
    bytes: file.bytes,
    size: file.size,
    extension: file.extension,
    path: '',
    isLocalImage: isLocalImage,
  );
}
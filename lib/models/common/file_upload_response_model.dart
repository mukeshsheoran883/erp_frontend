import 'dart:convert';

import 'package:invently/assortment/utils/json_utils.dart';
import 'package:invently/utils/static_keys.dart';
import 'package:flutter/foundation.dart';

class FileUploadResponseModel {
  String fileUrl;

  FileUploadResponseModel({required this.fileUrl});

  factory FileUploadResponseModel.fromJson(Map<String, dynamic> json) =>
      FileUploadResponseModel(fileUrl: Ju.gV(json, 'file_url') ?? '');
}

class FileUploadModel {
  Uint8List bytes;
  String fileName;
  BucketKeys bucketKeys;

  FileUploadModel({required this.bytes, required this.fileName, required this.bucketKeys});

  Map<String, dynamic> toJson() => {
        'bucket_name': bucketKeys.value,
        'file_name': fileName,
        'files': base64Encode(bytes),
      };
}

import 'package:uuid/uuid.dart';

class FileSize {
  final num size;
  final FileSizeUnit unit;

  const FileSize({required this.size, required this.unit});

  String getHumanReadableForm({FileSizeUnit? inUnit, int? decimals = 3}) {
    num outputSize = size;
    final FileSizeUnit outputUnit = inUnit ?? unit;
    if (outputUnit == FileSizeUnit.bytes) outputSize = toBytes();
    if (outputUnit == FileSizeUnit.kb) outputSize = toKB();
    if (outputUnit == FileSizeUnit.mb) outputSize = toMB();
    if (outputUnit == FileSizeUnit.gb) outputSize = toGB();
    if (outputUnit == FileSizeUnit.tb) outputSize = toTB();

    if (decimals != null) return '${outputSize.toStringAsFixed(decimals)} ${outputUnit.name}';

    return '$outputSize ${outputUnit.name}';
  }

  num toBytes() {
    if (unit == FileSizeUnit.kb) return size * 1024;
    if (unit == FileSizeUnit.mb) return size * 1024 * 1024;
    if (unit == FileSizeUnit.gb) return size * 1024 * 1024 * 1024;
    if (unit == FileSizeUnit.tb) return size * 1024 * 1024 * 1024 * 1024;

    /// return in bytes
    return size;
  }

  num toKB() {
    if (unit == FileSizeUnit.bytes) return size / 1024;
    if (unit == FileSizeUnit.mb) return size * 1024;
    if (unit == FileSizeUnit.gb) return size * 1024 * 1024;
    if (unit == FileSizeUnit.tb) return size * 1024 * 1024 * 1024;

    /// return in kilo bytes
    return size;
  }

  num toMB() {
    if (unit == FileSizeUnit.bytes) return size / 1024 / 1024;
    if (unit == FileSizeUnit.kb) return size / 1024;
    if (unit == FileSizeUnit.gb) return size * 1024;
    if (unit == FileSizeUnit.tb) return size * 1024 * 1024;

    /// return in MB
    return size;
  }

  num toGB() {
    if (unit == FileSizeUnit.bytes) return size / 1024 / 1024 / 1024;
    if (unit == FileSizeUnit.kb) return size / 1024 / 1024;
    if (unit == FileSizeUnit.mb) return size / 1024;
    if (unit == FileSizeUnit.tb) return size * 1024;

    /// return in GB
    return size;
  }

  num toTB() {
    if (unit == FileSizeUnit.bytes) return size / 1024 / 1024 / 1024 / 1024;
    if (unit == FileSizeUnit.kb) return size / 1024 / 1024 / 1024;
    if (unit == FileSizeUnit.mb) return size / 1024 / 1024;
    if (unit == FileSizeUnit.gb) return size / 1024;

    /// return in TB
    return size;
  }
}

enum FileSizeUnit {
  bytes(value: 'bytes'),
  kb(value: 'KB'),
  mb(value: 'MB'),
  gb(value: 'GB'),
  tb(value: 'TB'),
  ;

  const FileSizeUnit({required this.value});

  final String value;
}

class FileUtils {
  static String generateUniqueName({required String fileName}) {
    final String? extension = fileName.split('.').lastOrNull;
    return '${const Uuid().v1()}.${extension ?? ''}';
  }

  static String getFileNameFromUrl({required String url}) {
    final String? fileName = url.split('file_name=').lastOrNull;
    return fileName ?? '';
  }
}

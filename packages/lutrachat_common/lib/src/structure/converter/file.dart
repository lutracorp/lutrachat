import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

/// Converts a file to a path and vice versa.
final class FileConverter extends JsonConverter<File, String> {
  const FileConverter();

  /// Ready to go instance of this converter.
  static const FileConverter instance = FileConverter();

  @override
  File fromJson(String json) => File(json);

  @override
  String toJson(File object) => object.path;
}

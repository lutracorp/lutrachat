import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

/// Converts a directory to a path and vice versa.
final class DirectoryConverter extends JsonConverter<Directory, String> {
  const DirectoryConverter();

  /// Ready to go instance of this converter.
  static const DirectoryConverter instance = DirectoryConverter();

  @override
  Directory fromJson(String json) => Directory(json);

  @override
  String toJson(Directory object) => object.path;
}

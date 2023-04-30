import 'dart:io';

extension FileSystemEntityX on FileSystemEntity {
  /// Name without the path
  String get name => path.split('/').last;
}

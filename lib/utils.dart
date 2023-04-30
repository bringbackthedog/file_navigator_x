// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:fnx/extensions.dart';
import 'package:fnx/file_associations.dart';
import 'package:flutter/foundation.dart';

class Utils {
  static void open(String path) {
    FileAssociations association = FileAssociations.fromPath(path);
    // Process.run("open -a '${association.openWith.macOSOpenCommand}'", [path]);

    String? openWith = association.openWith.macOSOpenCommand;
    if (openWith == null) {
      Process.run("open", [path]);
    } else {
      Process.run("open", ['-a', openWith, path]);
    }
  }

  /// Open file with default application
  // static void openFile(String path) {
  //   Process.run('xdg-open', [path]);
  // }

  /// Open with default application macos
  static void openWithFinder(String path) {
    Process.run('open', [path]);
  }

  /// Open path with VS Code
  static void openWithVSCode(String path) {
    Process.run('code', [path]);
  }

  static String _currentPath = homeDir;

  static get currentPath => _currentPath;

  static void changePath(String newPath) {
    _currentPath = newPath;
  }

  /// Get the user's home directory path
  static String get homeDir {
    String? homeDir = Platform.environment['HOME'];

    if (homeDir == null) {
      throw Exception('Could not find HOME environment variable');
    }

    return homeDir;
  }

  /// List all files and directories in a directory
  static List<FileSystemEntity> listDirContent({
    String? path,
    bool showHidden = false,
    bool showDirectories = true,
    bool showFiles = true,
  }) {
    path ??= homeDir;

    // var filePaths = <String>[];
    // var files = <FileSystemEntity>[];

    final dir = Directory(path);
    final files = dir.listSync().where((file) {
      bool isFile = FileSystemEntity.isFileSync(file.path);
      bool isDir = FileSystemEntity.isDirectorySync(file.path);

      var entityName = file.path.split('/').last;

      // Remove directories
      if (!isFile && !isDir) {
        return false;
      } else if (isDir && !showDirectories) {
        return false;
      } else if (isFile && !showFiles) {
        return false;
      }

      // Don't add hidden files and directories
      if (entityName.startsWith('.') && !showHidden) {
        return false;
      }

      return true;
    }).toList();

    // Sort alphabetically
    files.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    // for (var file in files) {

    return files;
  }

  static bool isMacOS() {
    return defaultTargetPlatform == TargetPlatform.macOS;
  }

  static bool isLinux() {
    return defaultTargetPlatform == TargetPlatform.linux;
  }

  static bool isWindows() {
    return defaultTargetPlatform == TargetPlatform.windows;
  }

  /// Read environment variables
  static void readEnv() {
    final envVars = Platform.environment;
    envVars.forEach((key, value) {
      print('$key: $value');
    });
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  // final bool isMacOS = defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeSreen(),
    );
  }
}

class HomeSreen extends StatelessWidget {
  HomeSreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final filePaths = Utils.listFiles();

    return Scaffold(
      body: ListView.builder(
        itemCount: filePaths.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filePaths[index]),
          );
        },
      ),
    );
  }
}

/// Nav bar and spacing
class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          // 1/5 of screen width
          width: double.infinity,
          constraints: BoxConstraints(
            minWidth: 200,
            maxWidth: 300,
          ),
          child: Text('defaultTargetPlatform.toString()'),
        ),
        SizedBox(width: 10),
        VerticalDivider(thickness: 1, width: 1),
        SizedBox(width: 10),
      ],
    );
  }
}

class Utils {
  /// Get the user's home directory path
  static String get homeDir {
    String? homeDir = Platform.environment['HOME'];

    if (homeDir == null) {
      throw Exception('Could not find HOME environment variable');
    }

    return homeDir;
  }

  /// List all files in home directory
  static List<String> listFiles({String? path, bool showHidden = false}) {
    path ??= homeDir;

    var filePaths = <String>[];

    final dir = Directory(path);
    final files = dir.listSync();
    for (var file in files) {
      bool isFile = FileSystemEntity.isFileSync(file.path);
      // bool isDir = FileSystemEntity.isDirectorySync(file.path);

      // Remove the parent directory from the path
      var fileName = file.path.split('/').last;

      // Remove directories
      if (!isFile) {
        continue;
      }

      // Don't add hidden files and directories
      if (fileName.startsWith('.') && !showHidden) {
        continue;
      }

      filePaths.add(fileName);
      // filePaths.add(file.path);
    }

    return filePaths;
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

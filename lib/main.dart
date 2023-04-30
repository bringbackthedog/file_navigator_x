// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class HomeSreen extends StatefulWidget {
  HomeSreen({
    super.key,
  });

  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  final filePaths = Utils.listFiles();

  int _currentlySelectedIdx = 0;

  int get currentlySelectedIdx => _currentlySelectedIdx;

  set currentlySelectedIdx(int idx) {
    if (idx < 0) {
      return;
    }

    if (idx >= filePaths.length) {
      return;
    }

    _currentlySelectedIdx = idx;
  }

  @override
  Widget build(BuildContext context) {
    final _focusNode = FocusNode();

    /// Change the focuss when the user presses up or down arrow keys
    RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          print('Up');
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          print('Down');
        }
      },
      child: Container(),
    );

    return Scaffold(
      body: Column(
        children: [
          Text(Utils.currentPath),
          Flexible(
            child: Focus(
              onKey: (node, event) {
                if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                  print('Up');
                  // TODO Change the focus to the previous item
                  currentlySelectedIdx = currentlySelectedIdx - 1;
                  setState(() {});
                } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                  print('Down');
                  currentlySelectedIdx = currentlySelectedIdx + 1;
                  setState(() {});
                }

                return KeyEventResult.handled;
              },
              autofocus: true,
              focusNode: _focusNode,
              child: ListView.builder(
                itemCount: filePaths.length,
                itemBuilder: (context, index) {
                  if (index == currentlySelectedIdx) {
                    return Container(
                      color: Colors.blue,
                      child: Text(filePaths[index].name),
                    );
                  }

                  return Text(filePaths[index].name);
                },
              ),
            ),
          ),
        ],
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

  /// List all files in home directory
  static List<FileSystemEntity> listFiles(
      {String? path, bool showHidden = false}) {
    path ??= homeDir;

    // var filePaths = <String>[];
    // var files = <FileSystemEntity>[];

    final dir = Directory(path);
    final files = dir.listSync().where((file) {
      bool isFile = FileSystemEntity.isFileSync(file.path);
      bool isDir = FileSystemEntity.isDirectorySync(file.path);
      var fileName = file.path.split('/').last;

      // Remove directories
      if (!isFile) {
        return false;
      }

      // Don't add hidden files and directories
      if (fileName.startsWith('.') && !showHidden) {
        return false;
      }

      return true;
    }).toList();

    // for (var file in files) {
    //   bool isFile = FileSystemEntity.isFileSync(file.path);
    //   // bool isDir = FileSystemEntity.isDirectorySync(file.path);

    //   // Remove the parent directory from the path
    //   var fileName = file.path.split('/').last;

    //   // Remove directories
    //   if (!isFile) {
    //     continue;
    //   }

    //   // Don't add hidden files and directories
    //   if (fileName.startsWith('.') && !showHidden) {
    //     continue;
    //   }

    //   // filePaths.add(fileName);
    //   files.add(file);
    // }

    // return filePaths;
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

extension on FileSystemEntity {
  /// Name without the path
  String get name => path.split('/').last;
}

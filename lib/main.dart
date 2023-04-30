// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const KeyExampleApp());

class KeyExampleApp extends StatelessWidget {
  const KeyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Key Handling Example')),
        body: const MyKeyExample(),
      ),
    );
  }
}

class MyKeyExample extends StatefulWidget {
  const MyKeyExample({super.key});

  @override
  State<MyKeyExample> createState() => _MyKeyExampleState();
}

class _MyKeyExampleState extends State<MyKeyExample> {
  // The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  // DEBUG
  static final debugPath = Utils.homeDir + '/development/practice/flutter';
  var files = Utils.listDirContent(path: debugPath);

  // var files = Utils.listDirContent();

  int _currentSelection = 0;

  int get currentSelection => _currentSelection;

  static int count = 0;
  set currentSelection(int index) {
    if (index < 0 || index >= files.length) {
      return;
    }
    // setState(() {
    _currentSelection = index;
    // });
  }

  @override
  void initState() {
    super.initState();
    // _focusNode.addListener(_onFocusChange);
  }

  // Focus nodes need to be disposed.
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Gets the position of a widget in the list view.
  void _getWidgetPosition() {
    final RenderObject? renderObject = _focusNode.context?.findRenderObject();
    if (renderObject == null) {
      throw Exception('Cannot find render object for focus node.');
    }

    final RenderAbstractViewport viewport =
        RenderAbstractViewport.of(renderObject);
    final double scrollOffset =
        viewport.getOffsetToReveal(renderObject, 0.0).offset;

    // DEBUG
    debugPrint('scrollOffset: $scrollOffset');
    // _scrollController.animateTo(
    //   scrollOffset,
    //   duration: Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );

    // if the widget will be off-screen, scroll
    if (scrollOffset < _scrollController.position.pixels) {
      _scrollController.jumpTo(scrollOffset);
    } else if (scrollOffset + 20 >
        _scrollController.position.pixels +
            _scrollController.position.viewportDimension) {
      _scrollController.jumpTo(
          // scrollOffset - _scrollController.position.viewportDimension + 20.0);
          scrollOffset - _scrollController.position.viewportDimension + 60.0);
    }
  }

  // void _onFocusChange() {
  //   // if (_focusNode.hasFocus) {
  //   if (true) {
  //     // If the widget associated with the focus node is off-screen,
  //     // scroll to it.
  //     final RenderObject? renderObject = _focusNode.context?.findRenderObject();
  //     if (renderObject == null) {
  //       throw Exception('Cannot find render object for focus node.');
  //       // return;
  //     }

  //     final RenderAbstractViewport viewport =
  //         RenderAbstractViewport.of(renderObject);
  //     final double scrollOffset =
  //         viewport.getOffsetToReveal(renderObject, 0.0).offset;

  //     // DEBUG
  //     debugPrint('scrollOffset: $scrollOffset');
  //     _scrollController.animateTo(
  //       scrollOffset,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //     // setState(() {});
  //   }
  // }

  // Handles the key events from the Focus widget and updates the
  // _message.
  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    if (event is! RawKeyDownEvent) {
      return KeyEventResult.skipRemainingHandlers;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        currentSelection--;
        _getWidgetPosition();
        // // if we can scroll up
        // bool canScrollUp = _scrollController.position.pixels > 0.0;
        // if (canScrollUp) {
        //   _scrollController.jumpTo(
        //     // current position
        //     _scrollController.position.pixels -
        //         // item height
        //         20.0,
        //   );
        // }
        // _onFocusChange();

        break;

      case LogicalKeyboardKey.arrowDown:
        currentSelection++;
        _getWidgetPosition();
        // _onFocusChange();

        // bool canScrollDown = _scrollController.position.pixels <
        //     _scrollController.position.maxScrollExtent;

        // if (canScrollDown) {
        //   _scrollController.jumpTo(
        //     // current position
        //     _scrollController.position.pixels +
        //         // item height
        //         20.0,
        //   );
        // }
        break;

      case LogicalKeyboardKey.enter:
        break;

      case LogicalKeyboardKey.arrowRight:
        // Open file or directory
        if (FileSystemEntity.isDirectorySync(files[currentSelection].path)) {
          Utils.changePath(files[currentSelection].path);
          files = Utils.listDirContent(path: Utils.currentPath);
          currentSelection = 0;
        }
        setState(() {});

        break;

      case LogicalKeyboardKey.arrowLeft:
        // Go back
        if (Utils.currentPath != Utils.homeDir) {
          Utils.changePath(Utils.currentPath
              .split('/')
              .sublist(0, Utils.currentPath.split('/').length - 1)
              .join('/'));
          files = Utils.listDirContent(path: Utils.currentPath);
          currentSelection = 0;
        }
        setState(() {});

        break;

      default:
    }
    // setState(
    //   () {
    //     if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
    //       currentSelection--;
    //     } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
    //       currentSelection++;
    //     }
    //   },
    // );

    setState(() {});

    // Returning true tells the framework that we handled the event.
    // Otherwise, the key event cascades to the widgets in the focused
    // widget's subtree.
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('Current path: ${Utils.currentPath}'),
        Expanded(
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: DefaultTextStyle(
              style: textTheme.bodyLarge!.copyWith(
                fontFamily: 'monospace',
                fontSize: 16.0,
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: files.length,
                itemExtent: 20.0,
                itemBuilder: (BuildContext context, int index) {
                  if (index == currentSelection) {
                    // Is there space to scroll?
                    // if (_scrollController.position.maxScrollExtent <
                    //     index * 20.0) {
                    //   _scrollController.jumpTo(
                    //     index * 20.0,
                    //   );
                    // }
                    // _scrollController.position.ensureVisible(
                    //   index * 20.0,
                    //   duration: Duration(milliseconds: 300),
                    //   curve: Curves.easeOut,
                    // );
                    // _scrollController.animateTo(
                    //   index * 20.0,
                    //   duration: Duration(milliseconds: 300),
                    //   curve: Curves.easeOut,
                    // );
                    return Focus(
                      focusNode: _focusNode,
                      onKey: _handleKeyEvent,
                      child: Container(
                        color: Colors.blue,
                        child: Text(files[index].name),
                      ),
                    );
                  }
                  return Text(files[index].name);
                },
              ),
            ),
          ),
        ),
      ],
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

import 'dart:io';

import 'package:fnx/constants.dart';
import 'package:fnx/extensions.dart';
import 'package:fnx/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() => runApp(const KeyExampleApp());

class KeyExampleApp extends StatelessWidget {
  const KeyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBacgroundColor,
        body: App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  var files = Utils.listDirContent();

  int _currentSelection = 0;

  int get currentSelection => _currentSelection;

  set currentSelection(int index) {
    if (index < 0 || index >= files.length) {
      return;
    }
    _currentSelection = index;
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

  /// Gets the position of a widget in the list view and scrolls if we are
  /// at the edge of the viewport.
  void _updateScrollController() {
    final RenderObject? renderObject = _focusNode.context?.findRenderObject();
    if (renderObject == null) {
      throw Exception('Cannot find render object for focus node.');
    }

    final RenderAbstractViewport viewport =
        RenderAbstractViewport.of(renderObject);

    final double scrollOffset =
        viewport.getOffsetToReveal(renderObject, 0.0).offset;

    // ScrollActivityDelegate delegate = _scrollController.position.activity!.delegate;
    // DEBUG
    // debugPrint("scrollOffset: $scrollOffset, "
    //     "pixels: ${_scrollController.position.pixels}, "
    //     "viewportDimension: ${_scrollController.position.viewportDimension}");

    // if the widget will be off-screen, scroll it into view
    if (scrollOffset <= _scrollController.position.pixels) {
      _scrollController.animateTo(
        scrollOffset - kFileSystemEntityTileSize,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    } else if (scrollOffset + 20 >=
        _scrollController.position.pixels +
            _scrollController.position.viewportDimension) {
      _scrollController.animateTo(
        scrollOffset - _scrollController.position.viewportDimension + 60.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  }

  // Handles the key events from the Focus widget and updates the
  // _message.
  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    if (event is! RawKeyDownEvent) {
      return KeyEventResult.skipRemainingHandlers;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        currentSelection--;
        setState(() {});
        _updateScrollController();

        break;

      case LogicalKeyboardKey.arrowDown:
        currentSelection++;
        setState(() {});
        _updateScrollController();

        break;

      case LogicalKeyboardKey.enter:
        // Open file or directory
        Utils.open(files[currentSelection].path);
        break;

      case LogicalKeyboardKey.arrowRight:
        // Open file or directory
        if (FileSystemEntity.isDirectorySync(files[currentSelection].path)) {
          Utils.changePath(files[currentSelection].path);
          files = Utils.listDirContent(path: Utils.currentPath);
          currentSelection = 0;
        }
        //  else if (FileSystemEntity.isFileSync(files[currentSelection].path)) {
        //   // Utils.openWithVSCode(files[currentSelection].path);
        //   Utils.open(files[currentSelection].path);
        // }
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

      case LogicalKeyboardKey.space:
        // Open file or directory
        Utils.open(Utils.currentPath);

        setState(() {});
        break;

      default:
        debugPrint('Key not handled: ${event.logicalKey}');
        return KeyEventResult.ignored;
    }

    // setState(() {});

    // Returning true tells the framework that we handled the event.
    // Otherwise, the key event cascades to the widgets in the focused
    // widget's subtree.
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DefaultTextStyle(
      style: textTheme.bodyLarge!.copyWith(
        fontFamily: 'monospace',
        fontSize: 16.0,
        color: kFileSystemEntityTextColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${Utils.currentPath}'),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              // color: Colors.white,
              alignment: Alignment.center,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: files.length,
                itemExtent: kFileSystemEntityTileSize,
                itemBuilder: (BuildContext context, int index) {
                  var icon = files[index] is Directory
                      ? Icons.folder_outlined
                      : Icons.insert_drive_file_outlined;

                  if (index == currentSelection) {
                    return Focus(
                      focusNode: _focusNode,
                      onKey: _handleKeyEvent,
                      child: Container(
                        color: kSelectionColor,
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: kFileSystemEntityIconColor,
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                files[index].name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: kFileSystemEntityIconColor,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              files[index].name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

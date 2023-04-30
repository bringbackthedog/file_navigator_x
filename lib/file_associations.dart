// open -a "Visual Studio Code"
//  open -a TextEdit filename

import 'dart:io';

enum FileAssociations {
  app(openWith: ApplicationAssociations.none),
  txt(openWith: ApplicationAssociations.textedit),

  // TODO IMAGES
  png(openWith: ApplicationAssociations.preview),
  jpg(openWith: ApplicationAssociations.preview),
  jpeg(openWith: ApplicationAssociations.preview),

  // TODO DEFAULT FOR ANY FILE TYPE
  any(openWith: ApplicationAssociations.vscode);

  const FileAssociations({
    required this.openWith,
  });

  final ApplicationAssociations openWith;

  factory FileAssociations.fromPath(String path) {
    // Get file extension
    String ext = path.split('.').last;

    // Get file association
    FileAssociations association = FileAssociations.values.firstWhere(
      (element) => element.name == ext,
      orElse: () => FileAssociations.any,
    );

    return association;
  }
}

enum ApplicationAssociations {
  none,

  vscode(macOSOpenCommand: 'Visual Studio Code'),

  // TODO IMAGES
  preview(macOSOpenCommand: 'Preview'),

  // TODO DEFAULT FOR ANY FILE TYPE
  textedit(macOSOpenCommand: 'TextEdit');

  const ApplicationAssociations({
    this.macOSOpenCommand,
  });

  /// Application argument passed to macOS `open` command
  final String? macOSOpenCommand;

  factory ApplicationAssociations.fromPath(String path) {
    // Get file extension
    String ext = path.split('.').last;
    // Get file association
    ApplicationAssociations association = ApplicationAssociations.values
        .firstWhere((element) => element.name == ext);
    return association;
  }
}

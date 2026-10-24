import 'dart:io';

import 'package:flutter/services.dart';

Future<void> loadSrFonts() async {
  final flutterRoot = File(Platform.resolvedExecutable)
      .parent
      .parent
      .parent
      .parent
      .parent
      .parent;
  final materialIconsFile = File(
    '${flutterRoot.path}/bin/cache/artifacts/material_fonts/'
    'MaterialIcons-Regular.otf',
  );

  final poppins = FontLoader('Poppins')
    ..addFont(_loadFont(File('assets/fonts/poppins_regular.ttf')))
    ..addFont(_loadFont(File('assets/fonts/poppins_medium.ttf')))
    ..addFont(_loadFont(File('assets/fonts/poppins_semi_bold.ttf')))
    ..addFont(_loadFont(File('assets/fonts/poppins_bold.ttf')))
    ..addFont(_loadFont(File('assets/fonts/poppins_extra_bold.ttf')));
  final materialIcons = FontLoader('MaterialIcons')
    ..addFont(_loadFont(materialIconsFile));

  await poppins.load();
  await materialIcons.load();
}

Future<ByteData> _loadFont(File file) async {
  final bytes = await file.readAsBytes();
  return ByteData.sublistView(bytes);
}

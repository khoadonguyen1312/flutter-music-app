import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:palette_generator/palette_generator.dart';

Future<List<Color>> getImagePalette(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator =
  await PaletteGenerator.fromImageProvider(
    imageProvider,
    maximumColorCount: 20,
  );

  return paletteGenerator.paletteColors
      .map((swatch) => swatch.color)
      .take(4)
      .toList();
}

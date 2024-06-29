import 'dart:ui' as ui;
import 'package:flutter/services.dart';

Future<Uint8List> getBytesFromAsset(String path, double width) async {
    var imageData = await rootBundle.load(path);
    var imageCodec = await ui.instantiateImageCodec(
      imageData.buffer.asUint8List(),
      targetWidth: width.round(),
    );
    var imageFrameInfo = await imageCodec.getNextFrame();
    var imageByteData = await imageFrameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return imageByteData!.buffer.asUint8List();
  }
import 'dart:async';
import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final barcodeNotifierProvider =
    AsyncNotifierProvider.autoDispose<BarCodeNotifier, File?>(
        BarCodeNotifier.new,
        name: "barcodeNotifierProvider");

class BarCodeNotifier extends AutoDisposeAsyncNotifier<File?> {
  @override
  FutureOr<File?> build() async {
    return null;
  }

  Future<void> generateBarCode({
    required Barcode bc,
    required String data,
    String? filename,
    required double width,
    required double height,
    required double fontHeight,
  }) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(
      () async {
        /// Create the Barcode
        final svg = bc.toSvg(
          data,
          width: width,
          height: height,
          fontHeight: fontHeight,
        );
        final dir = await getTemporaryDirectory();

        // Save the image
        filename ??= bc.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
        return await File('${dir.path}/$filename.svg').writeAsString(svg);
      },
    );
  }
}

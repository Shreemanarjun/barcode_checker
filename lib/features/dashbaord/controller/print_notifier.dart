import 'dart:async';
import 'dart:io';

import 'package:barcode_checker/bootstrap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';

final printPod = AsyncNotifierProvider.autoDispose
    .family<PrintNotifier, bool?, File>(PrintNotifier.new);

class PrintNotifier extends AutoDisposeFamilyAsyncNotifier<bool?, File> {
  @override
  FutureOr<bool?> build(File arg) {
    return null;
  }

  Future<void> printImage({required Printer printer}) async {
    talker.debug(printer);
    state = await AsyncValue.guard(
      () async {
        final bytes = await arg.readAsBytes();
        final flutterThermalPrinterPlugin = ref.watch(themalPrinterProvider);
        final connected = await flutterThermalPrinterPlugin.connect(printer);
        if (!connected) {
          return false;
        }

        await flutterThermalPrinterPlugin.printData(printer, bytes);

        return true;
      },
    );
  }
}

final themalPrinterProvider =
    Provider.autoDispose<FlutterThermalPrinter>((ref) {
  final flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;
  return flutterThermalPrinterPlugin;
});

final printersProvider =
    StreamProvider.autoDispose<List<Printer>>((ref) async* {
  final flutterThermalPrinterPlugin = ref.watch(themalPrinterProvider);
  await flutterThermalPrinterPlugin.getPrinters(connectionTypes: [
    ConnectionType.USB,
  ]);
  yield* flutterThermalPrinterPlugin.devicesStream;
});

import 'package:barcode_checker/core/router/router.gr.dart';
import 'package:barcode_checker/core/router/router_pod.dart';
import 'package:barcode_checker/features/dashbaord/controller/qr_image_generator.dart';
import 'package:barcode_checker/shared/riverpod_ext/asynvalue_easy_when.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class QrImageView extends ConsumerWidget {
  const QrImageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrfile = ref.watch(barcodeNotifierProvider);
    return qrfile.easyWhen(
      data: (data) {
        return data != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: SvgPicture.file(
                      data,
                      fit: BoxFit.fill,
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Print 1"),
                    onPressed: () {
                      ref
                          .read(autorouterProvider)
                          .navigate(PrinterDialogRoute(file: data));
                    },
                  )
                ],
              )
            : "No image generated".text.center.lg.make();
      },
    );
  }
}

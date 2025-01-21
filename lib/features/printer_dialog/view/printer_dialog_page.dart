import 'package:barcode_checker/features/dashbaord/controller/print_notifier.dart';
import 'package:barcode_checker/shared/helper/global_helper.dart';
import 'package:barcode_checker/shared/riverpod_ext/asynvalue_easy_when.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:velocity_x/velocity_x.dart';

@RoutePage()
class PrinterDialogPage extends ConsumerStatefulWidget {
  final File file;
  const PrinterDialogPage({super.key, required this.file});

  @override
  ConsumerState<PrinterDialogPage> createState() => _PrinterDialogPageState();
}

class _PrinterDialogPageState extends ConsumerState<PrinterDialogPage>
    with GlobalHelper {
  final _formKey = GlobalKey<FormBuilderState>();

  void print() async {
    if (_formKey.currentState?.validate() ?? false) {
      final fields = _formKey.currentState?.instantValue;
      final printer = fields?["printer"] as Printer;
      if (printer.isConnected == true) {
        await ref
            .read(printPod(widget.file).notifier)
            .printImage(printer: printer);
      } else {
        showErrorSnack(
          child: Text("Printer is not connected"),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final printingAsync = ref.watch(printPod(widget.file));
    return SizedBox(
      height: 200,
      child: Dialog(
        insetPadding: EdgeInsets.all(12),
        child: Material(
          child: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer(
                    builder: (context, cref, child) {
                      final printersAsync = ref.watch(printersProvider);
                      return printersAsync.easyWhen(
                        data: (printers) {
                          return FormBuilderDropdown(
                            name: "printer",
                            items: printers
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                        "${e.address} ${e.name} ${e.productId} ${e.vendorId} ${e.connectionType}"),
                                  ),
                                )
                                .toList(),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  printingAsync.easyWhen(
                    data: (data) {
                      return switch (data) {
                        null => Text("Printing not started yet"),
                        true => Text("Done Printing"),
                        false => Text("Unable to Print"),
                      };
                    },
                  ),
                  ElevatedButton(
                    child: Text("Print"),
                    onPressed: () {
                      print();
                    },
                  ).p12()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:barcode_checker/features/dashbaord/controller/qr_image_generator.dart';
import 'package:barcode_checker/features/dashbaord/view/qr_image_view.dart';
import 'package:barcode_checker/shared/helper/global_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcode/barcode.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:velocity_x/velocity_x.dart';

@RoutePage()
class DashbaordPage extends ConsumerStatefulWidget {
  const DashbaordPage({super.key});

  @override
  ConsumerState<DashbaordPage> createState() => _DashbaordPageState();
}

class _DashbaordPageState extends ConsumerState<DashbaordPage>
    with GlobalHelper {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void bargenerateListener(
    AsyncValue<File?>? previous,
    AsyncValue<File?> next,
  ) async {
    if (next is AsyncError) {
      showErrorSnack(
        child: Text(next.error?.toString() ?? "Unknown Error"),
      );
    }
    if (next is AsyncData && next.valueOrNull != null) {
      showSuccessSnack(
        child: Text("Barcode generated successfully for ${next.requireValue}"),
      );
    }
  }

  void generateImage() async {
    if (_formKey.currentState?.validate() ?? false) {
      final fields = _formKey.currentState?.instantValue;
      print(fields);
      final data = fields?["data"] as String;
      final barcode = fields?["barcode"] as BarcodeType;
      final height = fields?["height"] as double;
      final width = fields?["width"] as double;
      final fontHeight = fields?["fontHeight"] as double;
      ref.read(barcodeNotifierProvider.notifier).generateBarCode(
            bc: Barcode.fromType(barcode),
            data: data,
            height: height,
            width: width,
            fontHeight: fontHeight,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      barcodeNotifierProvider,
      bargenerateListener,
    );
    return Scaffold(
      body: FormBuilder(
        key: _formKey,
        initialValue: {
          "data": "sfasdsadasfdsgfgs",
          "barcode": BarcodeType.Code128,
          "height": "150.0",
          "width": " 100.0",
          "fontHeight": "10.0",
        },
        child: Column(
          spacing: 20,
          children: [
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: "data",
              decoration: InputDecoration(
                labelText: "Data",
                hintText: "Enter data",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            FormBuilderDropdown(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: "barcode",
              decoration: InputDecoration(
                labelText: "Barcode",
              ),
              items: BarcodeType.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
            ),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: "height",
              decoration: InputDecoration(
                labelText: "height",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
              valueTransformer: (value) {
                if (value == null) {
                  return null;
                }
                return double.parse(value);
              },
            ),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: "width",
              decoration: InputDecoration(
                labelText: "width",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
              valueTransformer: (value) => double.tryParse(value ?? ""),
            ),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: "fontHeight",
              decoration: InputDecoration(
                labelText: "fontHeight",
              ),
              validator: FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.range(0.1, 32)
                ],
              ),
              valueTransformer: (value) => double.tryParse(value ?? ""),
            ),
            ElevatedButton(
              child: Text(
                "Generate Barcode",
              ),
              onPressed: () {
                generateImage();
              },
            ),
            QrImageView()
          ],
        ).p24(),
      ).scrollVertical(),
    );
  }
}

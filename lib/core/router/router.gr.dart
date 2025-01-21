// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i6;

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:barcode_checker/features/counter/view/counter_page.dart'
    deferred as _i1;
import 'package:barcode_checker/features/dashbaord/view/dashbaord_page.dart'
    as _i2;
import 'package:barcode_checker/features/printer_dialog/view/printer_dialog_page.dart'
    as _i3;
import 'package:flutter/material.dart' as _i5;

/// generated route for
/// [_i1.CounterPage]
class CounterRoute extends _i4.PageRouteInfo<void> {
  const CounterRoute({List<_i4.PageRouteInfo>? children})
      : super(
          CounterRoute.name,
          initialChildren: children,
        );

  static const String name = 'CounterRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return _i4.DeferredWidget(
        _i1.loadLibrary,
        () => _i1.CounterPage(),
      );
    },
  );
}

/// generated route for
/// [_i2.DashbaordPage]
class DashbaordRoute extends _i4.PageRouteInfo<void> {
  const DashbaordRoute({List<_i4.PageRouteInfo>? children})
      : super(
          DashbaordRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashbaordRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.DashbaordPage();
    },
  );
}

/// generated route for
/// [_i3.PrinterDialogPage]
class PrinterDialogRoute extends _i4.PageRouteInfo<PrinterDialogRouteArgs> {
  PrinterDialogRoute({
    _i5.Key? key,
    required _i6.File file,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          PrinterDialogRoute.name,
          args: PrinterDialogRouteArgs(
            key: key,
            file: file,
          ),
          initialChildren: children,
        );

  static const String name = 'PrinterDialogRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PrinterDialogRouteArgs>();
      return _i3.PrinterDialogPage(
        key: args.key,
        file: args.file,
      );
    },
  );
}

class PrinterDialogRouteArgs {
  const PrinterDialogRouteArgs({
    this.key,
    required this.file,
  });

  final _i5.Key? key;

  final _i6.File file;

  @override
  String toString() {
    return 'PrinterDialogRouteArgs{key: $key, file: $file}';
  }
}

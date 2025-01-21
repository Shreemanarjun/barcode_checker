import 'package:auto_route/auto_route.dart';
import 'package:barcode_checker/core/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

/// This class used for defined routes and paths na dother properties
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  late final List<AutoRoute> routes = [
    AutoRoute(
      page: DashbaordRoute.page,
      path: '/',
      initial: true,
    ),
    CustomRoute(
      page: PrinterDialogRoute.page,
      path: "/printer1Dialog",
      customRouteBuilder:
          <T>(BuildContext context, Widget child, AutoRoutePage<T> page) {
        return DialogRoute(
          context: context,
          settings: page,
          barrierColor: Colors.transparent.withValues(alpha: 0.5),
          builder: (_) => SizedBox(
            height: context.screenHeight * 0.5,
            width: context.screenWidth * 0.5,
            child: child,
          ),
          useSafeArea: true,
        );
      },
    ),
  ];
}

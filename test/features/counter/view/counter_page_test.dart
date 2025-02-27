// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:barcode_checker/bootstrap.dart';
import 'package:barcode_checker/core/local_storage/app_storage_pod.dart';
import 'package:barcode_checker/features/counter/controller/counter_state_pod.dart';
import 'package:barcode_checker/features/counter/view/counter_page.dart';
import 'package:barcode_checker/i18n/strings.g.dart';
import 'package:barcode_checker/shared/pods/internet_checker_pod.dart';
import 'package:barcode_checker/shared/riverpod_ext/riverpod_observer.dart';
import 'package:barcode_checker/shared/pods/translation_pod.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CounterPage', () {
    late Box appBox;
    setUp(() async {
      appBox = await Hive.openBox('appBox', bytes: Uint8List(0));
    });
    tearDown(() {
      appBox.clear();
    });
    testWidgets('renders CounterView', (tester) async {
      final translation = AppLocale.en.buildSync();
      await tester.pumpApp(
        child: const CounterPage(),
        container: ProviderContainer(
          overrides: [
            enableInternetCheckerPod.overrideWith(
              (ref) => false,
            ),
            appBoxProvider.overrideWithValue(appBox),
            translationsPod.overrideWith((ref) => translation)
          ],
        ),
      );
      expect(find.byType(CounterView), findsOneWidget);
    });
  });

  group('CounterView', () {
    late Box appBox;
    setUp(() async {
      appBox = await Hive.openBox('appBox', bytes: Uint8List(0));
    });
    tearDown(() async {
      await appBox.clear();
    });
    testWidgets('renders current count', (tester) async {
      const state = 42;
      final translation = AppLocale.en.buildSync();
      final container = ProviderContainer(
        overrides: [
          enableInternetCheckerPod.overrideWith(
            (ref) => false,
          ),
          appBoxProvider.overrideWithValue(appBox),
          intialCounterValuePod.overrideWithValue(state),
          translationsPod.overrideWith((ref) => translation)
        ],
        observers: [MyObserverLogger(talker: talker)],
      );
      addTearDown(container.dispose);
      await tester.pumpApp(
        child: const CounterView(),
        container: container,
      );
      await tester.pumpAndSettle();

      expect(find.text('$state'), findsOneWidget);
    });

    testWidgets('calls increment when increment button is tapped',
        (tester) async {
      const state = 42;
      final translation = AppLocale.en.buildSync();
      await tester.pumpApp(
        child: const CounterView(),
        container: ProviderContainer(
          overrides: [
            enableInternetCheckerPod.overrideWith(
              (ref) => false,
            ),
            appBoxProvider.overrideWithValue(appBox),
            intialCounterValuePod.overrideWithValue(state),
            translationsPod.overrideWith((ref) => translation)
          ],
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('42'), findsNothing);
      expect(find.text('43'), findsOneWidget);
    });

    testWidgets('calls decrement when decrement button is tapped',
        (tester) async {
      const state = 42;
      final translation = AppLocale.en.buildSync();
      final container = ProviderContainer(
        overrides: [
          enableInternetCheckerPod.overrideWith(
            (ref) => false,
          ),
          appBoxProvider.overrideWithValue(appBox),
          intialCounterValuePod.overrideWithValue(state),
          translationsPod.overrideWith((ref) => translation)
        ],
      );

      await tester.pumpApp(
        child: const CounterView(),
        container: container,
      );

      await tester.runAsync(
        () async {
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(Icons.remove));
          await tester.pumpAndSettle();
          expect(find.text('42'), findsNothing);
          expect(find.text('41'), findsOneWidget);
        },
      );
    });
  });
}

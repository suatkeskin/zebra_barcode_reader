// Copyright (c) 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:zebra_barcode_reader_platform_interface/zebra_barcode_reader_platform_interface.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Can initialize the plugin', (WidgetTester tester) async {
    final ZebraBarcodeReaderPlatform signIn = ZebraBarcodeReaderPlatform.instance;
    expect(signIn, isNotNull);
  });

  testWidgets('Method channel handler is present', (WidgetTester tester) async {
    // isSignedIn can be called without initialization, so use it to validate
    // that the native method handler is present (e.g., that the channel name
    // is correct).
    final ZebraBarcodeReaderPlatform signIn = ZebraBarcodeReaderPlatform.instance;
    await expectLater(signIn.connect(), completes);
  });
}

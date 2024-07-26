// Copyright (c) 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

class InitParams {
  const InitParams({
    this.autoConnect = false,
  });

  final bool autoConnect;
}

class BarcodeReaderDto {
  const BarcodeReaderDto({
    required this.name,
  });

  final String name;
}

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  javaOut: 'android/src/main/java/com/zebra/plugins/barcode/Messages.java',
  javaOptions: JavaOptions(package: 'com.zebra.plugins.barcode'),
  copyrightHeader: 'pigeons/copyright.txt',
))
@HostApi()
abstract class ZebraBarcodeReaderApi {
  void init(InitParams params);

  void connect();

  void disconnect();
}

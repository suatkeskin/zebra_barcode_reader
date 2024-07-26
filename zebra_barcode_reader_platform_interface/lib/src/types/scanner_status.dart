// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Scanner Status
///
/// See also https://techdocs.zebra.com/datawedge/latest/guide/api/getscannerstatus/
enum ScannerStatus {
  /// Scanner is ready to be triggered
  waiting,

  /// Scanner is emitting a scanner beam
  scanning,

  /// Scanner is in one of the following states: enabled but not yet in the waiting state,
  /// in the suspended state by an intent (e.g. SUSPEND_PLUGIN) or disabled due to the hardware trigger
  idle,

  /// Scanner is disabled
  disabled,

  /// An external (Bluetooth or serial) scanner is connected
  connected,

  /// The external scanner is disconnected
  disconnected;

  bool get isConnected =>
      !(this == ScannerStatus.disabled || this == ScannerStatus.disconnected);
}

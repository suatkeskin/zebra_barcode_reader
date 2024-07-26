// Copyright 2024, Suat Keskin. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class BarcodeData {
  BarcodeData({
    required this.data,
    required this.type,
  });

  late final String data;
  late final String type;

  BarcodeData.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data'] = data;
    data['type'] = type;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeData &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          data == other.data;

  @override
  int get hashCode => type.hashCode ^ data.hashCode;

  @override
  String toString() {
    return 'BarcodeData{data: $data, type: $type}';
  }
}

package com.zebra.plugins.barcode;

import androidx.annotation.NonNull;

import com.zebra.plugins.barcode.Messages.ZebraBarcodeReaderApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * ZebraBarcodeReaderPlugin
 */
public class ZebraBarcodeReaderPlugin implements FlutterPlugin, ZebraBarcodeReaderApi {
    private BarcodeReaderDelegate barcodeReaderDelegate;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.barcodeReaderDelegate = new BarcodeReaderDelegate(binding);
        ZebraBarcodeReaderApi.setUp(binding.getBinaryMessenger(), this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        ZebraBarcodeReaderApi.setUp(binding.getBinaryMessenger(), null);
        barcodeReaderDelegate.dispose();
    }

    @Override
    public void init(@NonNull Messages.InitParams params) {
        if (params.getAutoConnect()) {
            barcodeReaderDelegate.connect(params.getReadingMode());
        }
    }

    @Override
    public void connect(@NonNull Long readingMode) {
        barcodeReaderDelegate.connect(readingMode);
    }

    @Override
    public void disconnect() {
        barcodeReaderDelegate.dispose();
    }

    @Override
    public void setReadingMode(@NonNull Long readingMode) {
        barcodeReaderDelegate.setReadingMode(readingMode);
    }
}

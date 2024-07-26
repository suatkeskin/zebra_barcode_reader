package com.zebra.plugins.barcode;

import static android.provider.ContactsContract.Intents.Insert.ACTION;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.Objects;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class BarcodeReaderDelegate extends BroadcastReceiver {

    private final Context applicationContext;
    private final DartMessenger dartMessenger;
    private ScannerStatus scannerStatus;

    public BarcodeReaderDelegate(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        applicationContext = binding.getApplicationContext();
        final MethodChannel methodChannel = new MethodChannel(binding.getBinaryMessenger(), "plugins.zebra.com/barcode");
        this.dartMessenger = new DartMessenger(applicationContext, methodChannel, new Handler(Looper.getMainLooper()));
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        final String action = intent.getAction();

        Log.d(getClass().getSimpleName(), "DataWedge Action:" + action);

        if (intent.hasExtra(DataWedgeConstants.EXTRA_RESULT_GET_VERSION_INFO)) {
            final Bundle versionInfo = intent.getBundleExtra(DataWedgeConstants.EXTRA_RESULT_GET_VERSION_INFO);
            assert versionInfo != null;
            final String dataWedgeVersion = versionInfo.getString("DATAWEDGE");
            Log.i(getClass().getSimpleName(), "DataWedge Version: " + dataWedgeVersion);
        } else if (intent.hasExtra(DataWedgeConstants.EXTRA_RESULT_SCANNER_STATUS)) {
            scannerStatus = ScannerStatus.parse(intent.getStringExtra(DataWedgeConstants.EXTRA_RESULT_SCANNER_STATUS));
            Log.d(getClass().getSimpleName(), "Scanner status: " + scannerStatus);
            dartMessenger.sendScannerStatusEvent(scannerStatus);
        }

        switch (Objects.requireNonNull(action)) {
            case DataWedgeConstants.ACTIVITY_INTENT_FILTER_ACTION:
                //  Received a barcode scan
                try {
                    final String decodedLabelType = intent.getStringExtra(DataWedgeConstants.DATA_WEDGE_INTENT_KEY_LABEL_TYPE);
                    final String decodedData = intent.getStringExtra(DataWedgeConstants.DATA_WEDGE_INTENT_KEY_DATA);
                    Log.i(getClass().getSimpleName(), "Scanner Result: Type is " + decodedLabelType + ", Data is " + decodedData);
                    dartMessenger.sendBarcodeReadEvent(decodedLabelType, decodedData);
                } catch (Exception e) {
                    //  Catch error if the UI does not exist when we receive the broadcast...
                    Log.e(getClass().getSimpleName(), "Received a barcode scan error", e);
                }
                break;
            case DataWedgeConstants.ACTION_RESULT:
                // Register to receive the result code
                if ((intent.hasExtra(DataWedgeConstants.EXTRA_RESULT)) && (intent.hasExtra(DataWedgeConstants.EXTRA_COMMAND))) {
                    final String command = intent.getStringExtra(DataWedgeConstants.EXTRA_COMMAND);
                    final String result = intent.getStringExtra(DataWedgeConstants.EXTRA_RESULT);
                    final StringBuilder info = new StringBuilder();
                    if (intent.hasExtra(DataWedgeConstants.EXTRA_RESULT_INFO)) {
                        final Bundle resultInfo = intent.getBundleExtra(DataWedgeConstants.EXTRA_RESULT_INFO);
                        assert resultInfo != null;
                        final Set<String> keys = resultInfo.keySet();
                        for (String key : keys) {
                            Object object = resultInfo.get(key);
                            if (object instanceof String) {
                                info.append(key).append(": ").append(object).append("\n");
                            } else if (object instanceof String[]) {
                                String[] codes = (String[]) object;
                                for (String code : codes) {
                                    info.append(key).append(": ").append(code).append("\n");
                                }
                            }
                        }
                        Log.d(getClass().getSimpleName(), String.format("Command: %s\nResult: %s\nResult Info: %s\n", command, result, info));
                    }
                }
                break;
            case DataWedgeConstants.ACTION_RESULT_NOTIFICATION:
                // Register for scanner change notification
                if (intent.hasExtra(DataWedgeConstants.EXTRA_RESULT_NOTIFICATION)) {
                    final Bundle extras = intent.getBundleExtra(DataWedgeConstants.EXTRA_RESULT_NOTIFICATION);
                    assert extras != null;
                    final String notificationType = extras.getString(DataWedgeConstants.EXTRA_RESULT_NOTIFICATION_TYPE);
                    if (notificationType != null) {
                        switch (notificationType) {
                            case DataWedgeConstants.EXTRA_KEY_VALUE_SCANNER_STATUS:
                                // Change in scanner status occurred
                                scannerStatus = ScannerStatus.parse(extras.getString(DataWedgeConstants.EXTRA_KEY_VALUE_NOTIFICATION_STATUS));
                                final String profileName = extras.getString(DataWedgeConstants.EXTRA_KEY_VALUE_NOTIFICATION_PROFILE_NAME);
                                final String displayScannerStatusText = String.format("%s, profile: %s", scannerStatus, profileName);
                                Log.d(getClass().getSimpleName(), "Scanner status: " + displayScannerStatusText);
                                dartMessenger.sendScannerStatusEvent(scannerStatus);
                                break;
                            case DataWedgeConstants.EXTRA_KEY_VALUE_PROFILE_SWITCH:
                                // Received change in profile
                                // For future enhancement
                                break;
                            case DataWedgeConstants.EXTRA_KEY_VALUE_CONFIGURATION_UPDATE:
                                // Configuration change occurred
                                // For future enhancement
                                break;
                        }
                    }
                }
                break;
        }
    }

    public void dispose() {
        if (!scannerStatus.isConnected()) {
            return;
        }
        applicationContext.unregisterReceiver(this);
        final Bundle bundle = new Bundle();
        bundle.putString(DataWedgeConstants.EXTRA_KEY_APPLICATION_NAME, applicationContext.getPackageName());
        bundle.putString(DataWedgeConstants.EXTRA_KEY_NOTIFICATION_TYPE, DataWedgeConstants.EXTRA_KEY_VALUE_SCANNER_STATUS);
        final Intent intent = new Intent();
        intent.setAction(ACTION);
        intent.putExtra(DataWedgeConstants.EXTRA_UNREGISTER_NOTIFICATION, bundle);
        applicationContext.sendBroadcast(intent);
    }

    public void connect() {
        Log.d(getClass().getSimpleName(), "DataWedge enabled, connecting...");
        registerScannerStatusChangeNotification();
        registerReceivers();

        // Get DataWedge version
        // Use GET_VERSION_INFO: http://techdocs.zebra.com/datawedge/latest/guide/api/getversioninfo/
        // must be called after registering BroadcastReceiver
        sendDataWedgeIntentWithExtra(DataWedgeConstants.EXTRA_GET_VERSION_INFO, "");
        sendDataWedgeIntentWithExtra(DataWedgeConstants.EXTRA_GET_SCANNER_STATUS, "");

        createProfileIfNotExist();
    }

    private void createProfileIfNotExist() {
        // Send DataWedge intent with extra to create profile
        // Use CREATE_PROFILE: http://techdocs.zebra.com/datawedge/latest/guide/api/createprofile/
        sendDataWedgeIntentWithExtra(DataWedgeConstants.EXTRA_CREATE_PROFILE, getApplicationName());

        // Configure created profile to apply to this app
        final Bundle profileConfig = new Bundle();
        profileConfig.putString("PROFILE_NAME", getApplicationName());
        profileConfig.putString("PROFILE_ENABLED", "true");
        profileConfig.putString("CONFIG_MODE", "CREATE_IF_NOT_EXIST");  // Create profile if it does not exist

        // Configure barcode input plugin
        final Bundle barcodeConfig = new Bundle();
        barcodeConfig.putString("PLUGIN_NAME", "BARCODE");
        barcodeConfig.putString("RESET_CONFIG", "true"); //  This is the default
        final Bundle barcodeProps = new Bundle();
        barcodeConfig.putBundle("PARAM_LIST", barcodeProps);
        profileConfig.putBundle("PLUGIN_CONFIG", barcodeConfig);

        // Associate profile with this app
        final Bundle appConfig = new Bundle();
        appConfig.putString("PACKAGE_NAME", applicationContext.getPackageName());
        appConfig.putStringArray("ACTIVITY_LIST", new String[]{"*"});
        profileConfig.putParcelableArray("APP_LIST", new Bundle[]{appConfig});
        profileConfig.remove("PLUGIN_CONFIG");

        // Apply configs
        // Use SET_CONFIG: http://techdocs.zebra.com/datawedge/latest/guide/api/setconfig/
        sendDataWedgeIntentWithExtra(DataWedgeConstants.EXTRA_SET_CONFIG, profileConfig);

        // Configure intent output for captured data to be sent to this app
        final Bundle intentConfig = new Bundle();
        intentConfig.putString("PLUGIN_NAME", "INTENT");
        intentConfig.putString("RESET_CONFIG", "true");
        final Bundle intentProps = new Bundle();
        intentProps.putString("intent_output_enabled", "true");
        intentProps.putString("intent_action", DataWedgeConstants.ACTIVITY_INTENT_FILTER_ACTION);
        intentProps.putString("intent_delivery", "2");
        intentConfig.putBundle("PARAM_LIST", intentProps);
        profileConfig.putBundle("PLUGIN_CONFIG", intentConfig);
        sendDataWedgeIntentWithExtra(DataWedgeConstants.EXTRA_SET_CONFIG, profileConfig);
    }

    public void registerReceivers() {
        final IntentFilter filter = new IntentFilter();
        filter.addAction(DataWedgeConstants.ACTION_RESULT_NOTIFICATION);   // for notification result
        filter.addAction(DataWedgeConstants.ACTION_RESULT);                // for error code result
        filter.addCategory(Intent.CATEGORY_DEFAULT);    // needed to get version info

        // register to received broadcasts via DataWedge scanning
        filter.addAction(DataWedgeConstants.ACTIVITY_INTENT_FILTER_ACTION);
        filter.addAction(DataWedgeConstants.ACTIVITY_ACTION_FROM_SERVICE);
        applicationContext.registerReceiver(this, filter);
    }

    private void registerScannerStatusChangeNotification() {
        // Register for status change notification
        // Use REGISTER_FOR_NOTIFICATION: http://techdocs.zebra.com/datawedge/latest/guide/api/registerfornotification/
        final Bundle bundle = new Bundle();
        bundle.putString(DataWedgeConstants.EXTRA_KEY_APPLICATION_NAME, applicationContext.getPackageName());
        bundle.putString(DataWedgeConstants.EXTRA_KEY_NOTIFICATION_TYPE, DataWedgeConstants.EXTRA_KEY_VALUE_SCANNER_STATUS);     // register for changes in scanner status
        sendDataWedgeIntentWithExtra(DataWedgeConstants.EXTRA_REGISTER_NOTIFICATION, bundle);
    }

    private void sendDataWedgeIntentWithExtra(String extraKey, Bundle extras) {
        final Intent dwIntent = new Intent();
        dwIntent.setAction(DataWedgeConstants.ACTION_DATA_WEDGE);
        dwIntent.putExtra(extraKey, extras);
        dwIntent.putExtra(DataWedgeConstants.EXTRA_SEND_RESULT, "true");
        applicationContext.sendBroadcast(dwIntent);
    }

    private void sendDataWedgeIntentWithExtra(String extraKey, String extraValue) {
        final Intent dwIntent = new Intent();
        dwIntent.setAction(DataWedgeConstants.ACTION_DATA_WEDGE);
        dwIntent.putExtra(extraKey, extraValue);
        dwIntent.putExtra(DataWedgeConstants.EXTRA_SEND_RESULT, "true");
        dwIntent.putExtra(DataWedgeConstants.EXTRA_RESULT_CATEGORY, Intent.CATEGORY_DEFAULT);
        this.applicationContext.sendBroadcast(dwIntent);
    }

    private String getApplicationName() {
        final ApplicationInfo applicationInfo = applicationContext.getApplicationInfo();
        int stringId = applicationInfo.labelRes;
        return stringId == 0 ? applicationInfo.nonLocalizedLabel.toString() : applicationContext.getString(stringId);
    }
}

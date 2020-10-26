package com.search.my_camera;

import android.Manifest;
import android.app.Activity;

import com.karumi.dexter.Dexter;
import com.karumi.dexter.MultiplePermissionsReport;
import com.karumi.dexter.PermissionToken;
import com.karumi.dexter.listener.PermissionRequest;
import com.karumi.dexter.listener.multi.MultiplePermissionsListener;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


public class MyCameraPlugin implements MethodCallHandler {
    private Activity activity;

    private MyCameraPlugin(Registrar registrar) {
        this.activity = registrar.activity();
    }

    public static void registerWith(Registrar registrar) {
        if (registrar.activity() == null) {
            // When a background flutter view tries to register the plugin, the registrar has no activity.
            // We stop the registration process as this plugin is foreground only.
            return;
        }

        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "plugins.flutter.io/my_camera", new MyCameraFactory(registrar));

        final MethodChannel channel = new MethodChannel(registrar.messenger(), "my_camera");
        channel.setMethodCallHandler(new MyCameraPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("checkForPermission")) {
            checkForPermission(result);
        } else {
            result.notImplemented();
        }
    }

    private void checkForPermission(final MethodChannel.Result result) {
        Dexter.withActivity(activity)
                .withPermissions(Manifest.permission.CAMERA, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE)
                .withListener(new MultiplePermissionsListener() {
                    @Override
                    public void onPermissionsChecked(MultiplePermissionsReport report) {
                        result.success(report.areAllPermissionsGranted());
                    }

                    @Override
                    public void onPermissionRationaleShouldBeShown(List<PermissionRequest> permissions, PermissionToken token) {
                        token.continuePermissionRequest();
                    }
                })
                .check();
    }
}

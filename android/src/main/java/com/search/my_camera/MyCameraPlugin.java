package com.search.my_camera;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import com.karumi.dexter.Dexter;
import com.karumi.dexter.MultiplePermissionsReport;
import com.karumi.dexter.PermissionToken;
import com.karumi.dexter.listener.PermissionRequest;
import com.karumi.dexter.listener.multi.MultiplePermissionsListener;
import android.content.Intent;
import java.util.List;
import android.net.Uri;
import android.os.Bundle;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.uuzuche.lib_zxing.activity.CodeUtils;
import com.uuzuche.lib_zxing.activity.ZXingLibrary;

import java.io.ByteArrayOutputStream;

import static com.uuzuche.lib_zxing.activity.CodeUtils.RESULT_SUCCESS;
import static com.uuzuche.lib_zxing.activity.CodeUtils.RESULT_TYPE;


public class MyCameraPlugin implements MethodCallHandler,PluginRegistry.ActivityResultListener{
    private Activity activity;
    private int REQUEST_CODE = 100;
    private Result result = null;

    private int REQUEST_IMAGE = 101;
   /* private MyCameraPlugin(
            Registrar registrar) {
        this.activity = registrar.activity();
    }*/

    public static void registerWith(Registrar registrar) {
      ZXingLibrary.initDisplayOpinion(registrar.activity());
       // MyCameraPlugin plugin = new MyCameraPlugin(registrar.activity());
//registrar.addActivityResultListener();
        MyCameraPlugin plugin = new MyCameraPlugin(registrar.activity());
        //methodChannel.setMethodCallHandler(plugin);
        registrar.addActivityResultListener(plugin);
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "plugins.flutter.io/my_camera", new MyCameraFactory(registrar));

       // final MethodChannel channel = new MethodChannel(registrar.messenger(), "my_camera");
        MethodChannel channel = new MethodChannel(registrar.messenger(), "my_camera");
       // channel.setMethodCallHandler(new MyCameraPlugin(plugin));
        channel.setMethodCallHandler(plugin);
        //channel.setMethodCallHandler(plugin);




    }

    public MyCameraPlugin(Activity activity) {
        this.activity = activity;
        CheckPermissionUtils.initPermission(this.activity);
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        if (call.method.equals("checkForPermission")) {
            checkForPermission(result);
        } else {
            result.notImplemented();
        }
        this.result = result;

    }


    public boolean onActivityResult(int code, int resultCode, Intent intent) {
        System.out.println("hello : "+resultCode);
        System.out.println("hello : "+code);
        System.out.println("hello : "+intent.getExtras());
      //  System.out.println("hello : "+resul);
      //  System.out.println("hello : "+barcode);
        if (code == REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK && intent != null) {
                Bundle secondBundle = intent.getBundleExtra("secondBundle");
                if (secondBundle != null) {
                    try {
                        CodeUtils.AnalyzeCallback analyzeCallback = new CustomAnalyzeCallback(this.result, intent);
                        CodeUtils.analyzeBitmap(secondBundle.getString("path"), analyzeCallback);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    Bundle bundle = intent.getExtras();
                    if (bundle != null) {
                        if (bundle.getInt(RESULT_TYPE) == RESULT_SUCCESS) {
                            String barcode = bundle.getString(CodeUtils.RESULT_STRING);
                            System.out.println("barcode: "+barcode);

                            MyCamera.result.success(barcode);
                        }else{
                            this.result.success(null);
                        }
                    }
                }
            } else {
                String errorCode = intent != null ? intent.getStringExtra("ERROR_CODE") : null;
                if (errorCode != null) {
                    this.result.error(errorCode, null, null);
                }
            }
            return true;
        } else if (code == REQUEST_IMAGE) {
            if (intent != null) {
                Uri uri = intent.getData();
                try {
                    CodeUtils.AnalyzeCallback analyzeCallback = new CustomAnalyzeCallback(this.result, intent);
                    CodeUtils.analyzeBitmap(ImageUtil.getImageAbsolutePath(activity, uri), analyzeCallback);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            return true;
        }
        return false;
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

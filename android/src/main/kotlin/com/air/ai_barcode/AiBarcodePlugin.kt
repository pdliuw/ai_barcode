package com.air.ai_barcode

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** AiBarcodePlugin */
public class AiBarcodePlugin : FlutterPlugin, MethodCallHandler {
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "ai_barcode")
        channel.setMethodCallHandler(AiBarcodePlugin());

        /*注册：自己定义PlatformView*/
        flutterPluginBinding.platformViewRegistry.registerViewFactory("view_type_id_scanner_view", AndroidScannerViewFactory(flutterPluginBinding.binaryMessenger));
        flutterPluginBinding.platformViewRegistry.registerViewFactory("view_type_id_creator_view", AndroidCreatorViewFactory(flutterPluginBinding.binaryMessenger));
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "ai_barcode")
            channel.setMethodCallHandler(AiBarcodePlugin())
            /*注册：自己定义PlatformView*/
            registrar.platformViewRegistry().registerViewFactory("view_type_id_scanner_view", AndroidScannerViewFactory(registrar.messenger()));
            registrar.platformViewRegistry().registerViewFactory("view_type_id_creator_view", AndroidCreatorViewFactory(registrar.messenger()));
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when {
            call.method == "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            call.method == "test" -> result.success("Android test")
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }
}

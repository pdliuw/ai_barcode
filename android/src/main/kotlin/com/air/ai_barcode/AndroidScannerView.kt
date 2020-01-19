package com.air.ai_barcode

import android.content.Context
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import com.google.zxing.Result
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import me.dm7.barcodescanner.zxing.ZXingScannerView

/**
 * <p>
 * Created by air on 2019-12-02.
 * </p>
 */
class AndroidScannerView(binaryMessenger: BinaryMessenger, context: Context, viewid: Int, args: Any?) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, ZXingScannerView.ResultHandler {
    /**
     * 用于向Flutter发送数据
     */
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.eventChannelSink = events;
        this.eventChannelSink?.success("onListen");
    }

    override fun onCancel(arguments: Any?) {
    }

    /**
     * 识别二维码结果
     */
    override fun handleResult(rawResult: Result?) {

        this.channelResult.success("${rawResult?.toString()}");
//        this.eventChannelSink?.success("${rawResult?.toString()}")
    }

    /**
     * 接收Flutter传递过来的数据据
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        this.channelResult = result;
        when (call.method) {
            "startCamera" -> startCamera()
            "stopCamera" -> stopCamera()
            "resumeCameraPreview" -> resumeCameraPreview()
            "stopCameraPreview" -> stopCameraPreview()
            "openFlash" -> openFlash()
            "closeFlash" -> closeFlash()
            "toggleFlash" -> toggleFlash()
            else -> result.notImplemented()
        }
    }

    /**
     * 二维码扫描组件
     */
    var zxing: ZXingScannerView = ZXingScannerView(context);
    var linear: LinearLayout = LinearLayout(context);
    var textView: TextView = TextView(context);


    lateinit var channelResult: MethodChannel.Result;
    var eventChannelSink: EventChannel.EventSink? = null;

    init {
        textView.setText("Scanner view");
        /*
        MethodChannel
         */
        var methodChannel: MethodChannel = MethodChannel(binaryMessenger, "view_type_id_scanner_view_method_channel");
        methodChannel.setMethodCallHandler(this);
        /*
        EventChannel
         */
        var eventChannel: EventChannel = EventChannel(binaryMessenger, "view_type_id_scanner_view_event_channel");
        eventChannel.setStreamHandler(this);
    }

    override fun getView(): View {


        zxing.setAutoFocus(true);
        zxing.setAspectTolerance(0.5f);
        return zxing;
    }

    override fun dispose() {
    }

    override fun onFlutterViewDetached() {
    }

    override fun onFlutterViewAttached(flutterView: View) {
    }

    private fun startCamera() {
        zxing.startCamera();
    }

    private fun stopCamera() {
        zxing.stopCamera();
    }

    private fun resumeCameraPreview() {
        zxing.resumeCameraPreview(this);
    }

    private fun stopCameraPreview() {
        zxing.stopCameraPreview();
    }

    private fun openFlash() {
        zxing.flash = true;
    }

    private fun closeFlash() {
        zxing.flash = false;
    }

    private fun toggleFlash() {
        zxing.toggleFlash();
    }
}
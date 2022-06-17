package com.air.ai_barcode

import android.content.Context
import android.view.View
import android.widget.TextView
import com.google.zxing.BarcodeFormat
import com.google.zxing.ResultPoint
import com.journeyapps.barcodescanner.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


/**
 * <p>
 * Created by air on 2019-12-02.
 * </p>
 */
class AndroidScannerView(
    binaryMessenger: BinaryMessenger,
    context: Context?,
    viewid: Int,
    args: Any?
) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, BarcodeCallback,
    DecoratedBarcodeView.TorchListener {

    /**
     * 用于向Flutter发送数据
     */
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.mEventChannelSink = events;
    }

    override fun onCancel(arguments: Any?) {
        this.mEventChannelSink?.endOfStream();
    }


    override fun barcodeResult(result: BarcodeResult?) {

        if (result == null) {
            return;
        }
        if (result.text == null || result.text == mLastText) {
            // Prevent duplicate scans
            return
        }

        mLastText = result.text

        this.mEventChannelSink?.success(result.text.toString());
    }

    override fun possibleResultPoints(resultPoints: MutableList<ResultPoint>?) {
        super.possibleResultPoints(resultPoints)
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
    var mContext: Context? = context;
    var mZXingBarcode: DecoratedBarcodeView = DecoratedBarcodeView(context);


    var mTextView: TextView = TextView(context);
    var mLastText: String = "";


    lateinit var channelResult: MethodChannel.Result;
    var mEventChannelSink: EventChannel.EventSink? = null;

    var mTorchOn: Boolean = false

    init {
        mTextView.text = "Scanner view";
        /*
        MethodChannel
         */
        val methodChannel: MethodChannel =
            MethodChannel(binaryMessenger, "view_type_id_scanner_view_method_channel");
        methodChannel.setMethodCallHandler(this);
        /*
        EventChannel
         */
        val eventChannel: EventChannel =
            EventChannel(binaryMessenger, "view_type_id_scanner_view_event_channel");
        eventChannel.setStreamHandler(this);
    }

    override fun getView(): View {

        val formats: Collection<BarcodeFormat> =
            listOf(
                BarcodeFormat.UPC_A,
                BarcodeFormat.UPC_E,
                BarcodeFormat.EAN_8,
                BarcodeFormat.EAN_13,
                BarcodeFormat.RSS_14,
                BarcodeFormat.CODE_39,
                BarcodeFormat.CODE_93,
                BarcodeFormat.CODE_128,
                BarcodeFormat.ITF,
                BarcodeFormat.RSS_EXPANDED,
                BarcodeFormat.QR_CODE,
                BarcodeFormat.CODABAR,
            )
        mZXingBarcode.barcodeView.decoderFactory = DefaultDecoderFactory(formats)
        mZXingBarcode.setStatusText("")
        mZXingBarcode.decodeContinuous(this)
        mZXingBarcode.setTorchListener(this)


        return mZXingBarcode;
    }

    override fun dispose() {
    }

    override fun onFlutterViewDetached() {
    }

    override fun onFlutterViewAttached(flutterView: View) {
    }

    private fun startCamera() {
        mZXingBarcode.pauseAndWait();
    }

    private fun stopCamera() {
        mZXingBarcode.pause();
    }

    private fun resumeCameraPreview() {
        mZXingBarcode.resume()
    }

    private fun stopCameraPreview() {
        mZXingBarcode.pauseAndWait();
    }

    private fun openFlash() {
        mZXingBarcode.setTorchOn()
    }

    private fun closeFlash() {
        mZXingBarcode.setTorchOff()
    }

    private fun toggleFlash() {
        if (mTorchOn) {
            closeFlash()
        } else {
            openFlash()
        }
    }

    override fun onTorchOff() {
        mTorchOn = false
    }

    override fun onTorchOn() {
        mTorchOn = true
    }
}
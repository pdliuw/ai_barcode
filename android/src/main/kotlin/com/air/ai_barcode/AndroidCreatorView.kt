package com.air.ai_barcode

import android.content.Context
import android.graphics.Bitmap
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.Result
import com.google.zxing.WriterException
import com.google.zxing.common.BitMatrix
import com.google.zxing.qrcode.QRCodeWriter
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

import java.util.*


/**
 * <p>
 * Created by air on 2019-12-02.
 * </p>
 * <p>
 * Create QRCode view
 * </p>
 */
class AndroidCreatorView(
    binaryMessenger: BinaryMessenger,
    context: Context?,
    viewid: Int,
    args: Any?
) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
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
     * 接收Flutter传递过来的数据据
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        this.channelResult = result;
        when (call.method) {
            "updateQRCodeValue" -> updateQRCodeValue(call.argument("qrCodeContent"), 300, 300)
//            "stopCamera" -> stopCamera()
//            "resumeCameraPreview" -> resumeCameraPreview()
//            "stopCameraPreview" -> stopCameraPreview()
//            "openFlash" -> openFlash()
//            "closeFlash" -> closeFlash()
//            "toggleFlash" -> toggleFlash()
            else -> result.notImplemented()
        }
    }

    /**
     * QRCode creator view
     */
    var imageView: ImageView = ImageView(context);


    lateinit var channelResult: MethodChannel.Result;
    var eventChannelSink: EventChannel.EventSink? = null;
    var argsCreator: Any = args!!;

    init {
        /*
        MethodChannel
         */
        var methodChannel: MethodChannel =
            MethodChannel(binaryMessenger, "view_type_id_creator_view_method_channel");
        methodChannel.setMethodCallHandler(this);
        /*
        EventChannel
         */
        var eventChannel: EventChannel =
            EventChannel(binaryMessenger, "view_type_id_creator_view_event_channel");
        eventChannel.setStreamHandler(this);
    }

    override fun getView(): View {
        var qrContentString: String? = "";
        if (argsCreator is String) {
            if ((argsCreator as String).length > 0) {
                qrContentString = argsCreator as String;
            }

        } else if (argsCreator is Map<*, *>) {
            val map: Map<*, *> = argsCreator as Map<*, *>;
            if (map.containsKey("qrCodeContent")) {
                var qrCodeContentValue = map["qrCodeContent"];
                if (qrCodeContentValue is String) {
                    qrContentString = qrCodeContentValue;
                }
            }
        }
        return imageView;
    }

    override fun dispose() {
    }

    override fun onFlutterViewDetached() {
    }

    override fun onFlutterViewAttached(flutterView: View) {
    }


    private fun createQRImage(
        content: String?, widthPix: Int, heightPix: Int
    ): Bitmap? {
        try {
            val hints = HashMap<EncodeHintType, Any>()
            hints[EncodeHintType.CHARACTER_SET] = "UTF-8"
            hints[EncodeHintType.ERROR_CORRECTION] = ErrorCorrectionLevel.H
            hints[EncodeHintType.MARGIN] = 1
            var bitMatrix: BitMatrix? = null
            try {
                bitMatrix = QRCodeWriter().encode(
                    content, BarcodeFormat.QR_CODE, widthPix,
                    heightPix, hints
                )
            } catch (e: WriterException) {

            }
            val pixels = IntArray(widthPix * heightPix)
            for (y in 0 until heightPix) {
                for (x in 0 until widthPix) {
                    if (bitMatrix != null) {
                        if (bitMatrix.get(x, y)) {
                            pixels[y * widthPix + x] = -0x1000000
                        } else {
                            pixels[y * widthPix + x] = -0x1
                        }
                    } else {
                        return null
                    }
                }
            }
            val bitmap: Bitmap? = Bitmap.createBitmap(widthPix, heightPix, Bitmap.Config.ARGB_8888)
            bitmap!!.setPixels(pixels, 0, widthPix, 0, 0, widthPix, heightPix)
            return bitmap
        } catch (e: Exception) {

        }
        return null
    }

    /**
     * updateQRCodeValue
     */
    private fun updateQRCodeValue(content: String?, widthPix: Int, heightPix: Int) {
        imageView.setImageBitmap(null)
        imageView.setImageBitmap(createQRImage(content, widthPix, heightPix))
    }

}
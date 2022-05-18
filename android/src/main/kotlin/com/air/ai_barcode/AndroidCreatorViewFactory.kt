package com.air.ai_barcode

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * <p>
 * Created by air on 2019-12-02.
 * </p>
 */
class AndroidCreatorViewFactory(private var binaryMessenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return AndroidCreatorView(binaryMessenger, context, viewId, args);
    }
}
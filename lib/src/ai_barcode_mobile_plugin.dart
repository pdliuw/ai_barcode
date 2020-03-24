import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ai_barcode_platform_interface.dart';

///
/// AiBarcodeMobilePlugin
class AiBarcodeMobilePlugin extends AiBarcodePlatform {
  @override
  Widget buildView(BuildContext context) {
    return _cameraView(context);
  }

  /// Barcode reader widget
  ///
  /// Support android and ios platform barcode reader
  Widget _cameraView(BuildContext context) {
    TargetPlatform targetPlatform = Theme.of(context).platform;

    if (targetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: AiBarcodePlatform.viewId,
        onPlatformViewCreated: (int id) {
          onPlatformScannerViewCreated(id);
        },
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (targetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: AiBarcodePlatform.viewId,
        onPlatformViewCreated: (int id) {
          onPlatformScannerViewCreated(id);
        },
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      return Center(
        child: Text(
          "$unsupportedPlatformDescription",
        ),
      );
    }
  }
}

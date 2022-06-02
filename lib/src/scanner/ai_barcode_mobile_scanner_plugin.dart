import 'package:ai_barcode_platform_interface/ai_barcode_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// AiBarcodeMobileScannerPlugin
class AiBarcodeMobileScannerPlugin extends AiBarcodeScannerPlatform {
  @override
  Widget buildScannerView(BuildContext context) {
    return _cameraView(context);
  }

  /// Barcode reader widget
  ///
  /// Support android and ios platform barcode reader
  Widget _cameraView(BuildContext context) {
    final TargetPlatform targetPlatform = Theme.of(context).platform;
    if (targetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: AiBarcodePlatform.viewIdOfScanner,
        onPlatformViewCreated: (int id) {
          onPlatformScannerViewCreated(id);
        },
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (targetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: AiBarcodePlatform.viewIdOfScanner,
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

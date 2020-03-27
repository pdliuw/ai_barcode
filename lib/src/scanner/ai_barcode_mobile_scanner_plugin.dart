import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ai_barcode_platform_interface.dart';
import 'ai_barcode_platform_scanner_interface.dart';

///
/// AiBarcodeMobilePlugin
class AiBarcodeMobileScannerPlugin extends AiBarcodeScannerPlatform {
  @override
  Widget buildScannerView(BuildContext context) {
    return _cameraView(context);
  }

//  @override
//  Widget buildCreatorView(BuildContext context) {
//    return _barcodeCreator(context: context);
//  }

  /// Barcode reader widget
  ///
  /// Support android and ios platform barcode reader
  Widget _cameraView(BuildContext context) {
    TargetPlatform targetPlatform = Theme.of(context).platform;

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

//  Widget _barcodeCreator({BuildContext context}) {
//    TargetPlatform targetPlatform = Theme.of(context).platform;
//    if (targetPlatform == TargetPlatform.android) {
//      return AndroidView(
//        viewType: AiBarcodeScannerPlatform.viewIdOfCreator,
//        creationParams: <String, dynamic>{
//          "qrCodeContent":
//              AiBarcodeScannerPlatform.instance.initialValueOfCreator,
//        },
//        creationParamsCodec: StandardMessageCodec(),
//        onPlatformViewCreated: (int id) {
//          //created callback
//          onPlatformCreatorViewCreated(id);
//          //initial value
//          AiBarcodeScannerPlatform.instance.updateQRCodeValue(
//              AiBarcodeScannerPlatform.instance.initialValueOfCreator);
//        },
//      );
//    } else if (targetPlatform == TargetPlatform.iOS) {
//      return UiKitView(
//        viewType: AiBarcodeScannerPlatform.viewIdOfCreator,
//        creationParams: <String, dynamic>{
//          "qrCodeContent":
//              AiBarcodeScannerPlatform.instance.initialValueOfCreator,
//        },
//        creationParamsCodec: StandardMessageCodec(),
//        onPlatformViewCreated: (int id) {
//          //created callback
//          onPlatformCreatorViewCreated(id);
//          //initial value
//          AiBarcodeScannerPlatform.instance.updateQRCodeValue(
//              AiBarcodeScannerPlatform.instance.initialValueOfCreator);
//        },
//      );
//    } else {
//      return Text("Unsupported platform!");
//    }
//  }
}

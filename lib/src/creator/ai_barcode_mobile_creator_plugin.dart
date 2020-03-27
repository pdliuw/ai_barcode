import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ai_barcode_platform_interface.dart';
import 'ai_barcode_platform_creator_interface.dart';

/// AiBarcodeMobileCreatorPlugin
class AiBarcodeMobileCreatorPlugin extends AiBarcodeCreatorPlatform {
  @override
  Widget buildCreatorView(BuildContext context) {
    return _barcodeCreator(context: context);
  }

  /// Barcode widget
  Widget _barcodeCreator({BuildContext context}) {
    TargetPlatform targetPlatform = Theme.of(context).platform;
    if (targetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: AiBarcodePlatform.viewIdOfCreator,
        creationParams: <String, dynamic>{
          "qrCodeContent":
              AiBarcodeCreatorPlatform.instance.initialValueOfCreator,
        },
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          //created callback
          onPlatformCreatorViewCreated(id);
          //initial value
          AiBarcodeCreatorPlatform.instance.updateQRCodeValue(
              AiBarcodeCreatorPlatform.instance.initialValueOfCreator);
        },
      );
    } else if (targetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: AiBarcodePlatform.viewIdOfCreator,
        creationParams: <String, dynamic>{
          "qrCodeContent":
              AiBarcodeCreatorPlatform.instance.initialValueOfCreator,
        },
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          //created callback
          onPlatformCreatorViewCreated(id);
          //initial value
          AiBarcodeCreatorPlatform.instance.updateQRCodeValue(
              AiBarcodeCreatorPlatform.instance.initialValueOfCreator);
        },
      );
    } else {
      return Text("Unsupported platform!");
    }
  }
}

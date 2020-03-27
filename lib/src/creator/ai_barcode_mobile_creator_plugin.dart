import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
    } else if (targetPlatform == TargetPlatform.macOS) {
      QrImage qrImage = QrImage(
        data: AiBarcodeCreatorPlatform.instance.initialValueOfCreator,
        version: QrVersions.auto,
        size: 200.0,
      );
      return qrImage;
    } else if (targetPlatform == TargetPlatform.windows) {
      QrImage qrImage = QrImage(
        data: AiBarcodeCreatorPlatform.instance.initialValueOfCreator,
        version: QrVersions.auto,
        size: 200.0,
      );
      return qrImage;
    } else {
      return Center(
        child: Text(
          unsupportedPlatformDescription,
        ),
      );
    }
  }

  @override
  updateQRCodeValue(String value) {
    AiBarcodeCreatorPlatform.instance.initialValueOfCreator = value;
    notifyListeners();
    return super.updateQRCodeValue(value);
  }
}

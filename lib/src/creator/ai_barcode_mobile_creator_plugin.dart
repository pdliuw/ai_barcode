import 'package:ai_barcode_platform_interface/ai_barcode_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

/// AiBarcodeMobileCreatorPlugin
class AiBarcodeMobileCreatorPlugin extends AiBarcodeCreatorPlatform {
  @override
  Widget buildCreatorView(BuildContext context) {
    return _barcodeCreator(context: context);
  }

  /// Barcode widget
  Widget _barcodeCreator({required BuildContext context}) {
    if (UniversalPlatform.isAndroid) {
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
    } else if (UniversalPlatform.isIOS) {
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
      return Center(
        child: Text(
          "$unsupportedPlatformDescription",
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

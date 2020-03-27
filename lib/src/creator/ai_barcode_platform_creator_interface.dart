import 'package:ai_barcode/src/ai_barcode_platform_interface.dart';
import 'package:flutter/material.dart';

import 'ai_barcode_mobile_creator_plugin.dart';

/// AiBarcodeCreatorPlatform
abstract class AiBarcodeCreatorPlatform extends ChangeNotifier
    with AiBarcodePlatform {
  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements` which is forbidden for anything
  /// other than mocks (see class docs). This property provides a backdoor for mockito mocks to
  /// skip the verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  static AiBarcodeCreatorPlatform _instance = AiBarcodeMobileCreatorPlugin();

  /// The default instance of [AiBarcodeCreatorPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [AiBarcodeCreatorPlatform] when they
  /// register themselves.
  ///
  static AiBarcodeCreatorPlatform get instance => _instance;

  String _initialValueOfCreator = "please set QRCode value";

  String get initialValueOfCreator => _initialValueOfCreator;

  set initialValueOfCreator(String initialValue) {
    if (initialValue == null || initialValue.isEmpty) {
      return;
    }
    _initialValueOfCreator = initialValue;
  }

  ///
  /// Instance update
  static set instance(AiBarcodeCreatorPlatform instance) {
    if (!instance.isMock) {
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = instance;
  }

  /// Returns a widget displaying
  Widget buildCreatorView(BuildContext context) {
    throw UnimplementedError('buildCreatorView() has not been implemented.');
  }

  ///
  /// View created of creator widget
  onPlatformCreatorViewCreated(int id) {
    notifyListeners();
  }

  ///
  /// Update QR Code value
  updateQRCodeValue(String value) {
    AiBarcodePlatform.methodChannelCreator.invokeMethod("updateQRCodeValue", {
      "qrCodeContent": value,
    });
  }

  // This method makes sure that AiBarcode isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}
}

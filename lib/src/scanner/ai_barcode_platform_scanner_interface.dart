import 'package:ai_barcode/src/ai_barcode_platform_interface.dart';
import 'package:flutter/material.dart';

import 'ai_barcode_mobile_scanner_plugin.dart';

/// AiBarcodeScannerPlatform
abstract class AiBarcodeScannerPlatform extends ChangeNotifier
    with AiBarcodePlatform {
  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements` which is forbidden for anything
  /// other than mocks (see class docs). This property provides a backdoor for mockito mocks to
  /// skip the verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  static AiBarcodeScannerPlatform _instance = AiBarcodeMobileScannerPlugin();

  bool _isStartCamera = false;
  bool _isStartCameraPreview = false;
  bool _isOpenFlash = false;

  /// The default instance of [AiBarcodeScannerPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [AiBarcodeScannerPlatform] when they
  /// register themselves.
  ///
  static AiBarcodeScannerPlatform get instance => _instance;

  ///
  /// Whether start camera
  bool get isStartCamera => _isStartCamera;

  ///
  /// Whether start camera preview or start to recognize
  bool get isStartCameraPreview => _isStartCameraPreview;

  ///
  /// Whether open the flash
  bool get isOpenFlash => _isOpenFlash;

  String _unsupportedPlatformDescription =
      "Unsupported platforms, working hard to support";

  String get unsupportedPlatformDescription => _unsupportedPlatformDescription;

  set unsupportedPlatformDescription(String text) {
    if (text == null || text.isEmpty) {
      return;
    }
    _unsupportedPlatformDescription = text;
  }

  ///
  /// Instance update
  static set instance(AiBarcodeScannerPlatform instance) {
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

  /// Returns a widget displaying.
  Widget buildScannerView(BuildContext context) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  ///
  /// View created of scanner widget
  onPlatformScannerViewCreated(int id) {
    notifyListeners();
  }

  ///
  /// Start camera without open QRCode、BarCode scanner,this is just open camera.
  startCamera() async {
    _isStartCamera = true;
    AiBarcodePlatform.methodChannelScanner.invokeMethod("startCamera");
  }

  ///
  /// Stop camera.
  stopCamera() async {
    _isStartCamera = false;
    AiBarcodePlatform.methodChannelScanner.invokeMethod("stopCamera");
  }

  ///
  /// Start camera preview with open QRCode、BarCode scanner,this is open code scanner.
  Future<String> startCameraPreview() async {
    _isStartCameraPreview = true;
    return await AiBarcodePlatform.methodChannelScanner
        .invokeMethod("resumeCameraPreview");
  }

  ///
  /// Stop camera preview.
  stopCameraPreview() async {
    _isStartCameraPreview = false;
    AiBarcodePlatform.methodChannelScanner.invokeMethod("stopCameraPreview");
  }

  ///
  /// Open camera flash.
  openFlash() async {
    _isOpenFlash = true;
    AiBarcodePlatform.methodChannelScanner.invokeMethod("openFlash");
  }

  ///
  /// Close camera flash.
  closeFlash() async {
    _isOpenFlash = false;
    AiBarcodePlatform.methodChannelScanner.invokeMethod("closeFlash");
  }

  ///
  /// Toggle camera flash.
  toggleFlash() async {
    bool flash = isOpenFlash;
    _isOpenFlash = !flash;
    AiBarcodePlatform.methodChannelScanner.invokeMethod("toggleFlash");
  }

  // This method makes sure that AiBarcode isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}
}

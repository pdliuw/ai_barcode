import 'dart:async';
import 'dart:io';

import 'package:ai_barcode/src/creator/ai_barcode_mobile_creator_plugin.dart';
import 'package:ai_barcode/src/scanner/ai_barcode_mobile_scanner_plugin.dart';
import 'package:ai_barcode_platform_interface/ai_barcode_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
/// PlatformScannerWidget
///
/// Supported android and ios platform read barcode
// ignore: must_be_immutable
class PlatformAiBarcodeScannerWidget extends StatefulWidget {
  ///
  /// Controller.
  late ScannerController _platformScannerController;

  ///
  /// UnsupportedDescription
  String? _unsupportedDescription;

  ///
  /// Constructor.
  PlatformAiBarcodeScannerWidget({
    required ScannerController platformScannerController,
    String? unsupportedDescription,
  }) {
    _platformScannerController = platformScannerController;
    _unsupportedDescription = unsupportedDescription;
  }

  @override
  State<StatefulWidget> createState() {
    return _PlatformScannerWidgetState();
  }
}

///
/// _PlatformScannerWidgetState
class _PlatformScannerWidgetState
    extends State<PlatformAiBarcodeScannerWidget> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
  }

  ///
  /// CreatedListener.
  _widgetCreatedListener() {
    if (widget._platformScannerController._scannerViewCreated != null) {
      widget._platformScannerController._scannerViewCreated!();
      _streamSubscription = AiBarcodeScannerPlatform.instance
          .receiveBarcodeResult()
          .listen((event) {
        _receiveBarcodeResultCallback("$event");
      });
    }
  }

  void _receiveBarcodeResultCallback(String result) {
    widget._platformScannerController._scannerResult(result);
  }

  ///
  /// Web result callback
  void _webResultCallback(String result) {
    if (widget._platformScannerController._scannerResult != null) {
      //callback
      widget._platformScannerController._scannerResult(result);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
    //Release
    AiBarcodeScannerPlatform.instance.removeListener(_widgetCreatedListener);
    AiBarcodeScannerPlatform.instance.removeResultCallback(_webResultCallback);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        AiBarcodeScannerPlatform.instance = AiBarcodeMobileScannerPlugin();
      }
    }
    //Create
    AiBarcodeScannerPlatform.instance.addListener(_widgetCreatedListener);
    AiBarcodeScannerPlatform.instance.addResultCallback(_webResultCallback);
    AiBarcodeScannerPlatform.instance.unsupportedPlatformDescription =
        widget._unsupportedDescription;
    return AiBarcodeScannerPlatform.instance.buildScannerView(context);
  }
}

///
/// PlatformScannerController
class ScannerController {
  ///
  /// Result
  late Function(String result) _scannerResult;
  Function()? _scannerViewCreated;

  ///
  /// Constructor.
  ScannerController({
    required scannerResult(String result),
    scannerViewCreated,
  }) {
    _scannerResult = scannerResult;
    _scannerViewCreated = scannerViewCreated;
  }

  Function()? get scannerViewCreated => _scannerViewCreated;

  bool get isStartCamera => AiBarcodeScannerPlatform.instance.isStartCamera;

  bool get isStartCameraPreview =>
      AiBarcodeScannerPlatform.instance.isStartCameraPreview;

  bool get isOpenFlash => AiBarcodeScannerPlatform.instance.isOpenFlash;

  ///
  /// Start camera without open QRCode、BarCode scanner,this is just open camera.
  startCamera() {
    AiBarcodeScannerPlatform.instance.startCamera();
  }

  ///
  /// Stop camera.
  stopCamera() async {
    AiBarcodeScannerPlatform.instance.stopCamera();
  }

  ///
  /// Start camera preview with open QRCode、BarCode scanner,this is open code scanner.
  startCameraPreview() async {
    String code = await AiBarcodeScannerPlatform.instance.startCameraPreview();
    _scannerResult(code);
  }

  ///
  /// Stop camera preview.
  stopCameraPreview() async {
    AiBarcodeScannerPlatform.instance.stopCameraPreview();
  }

  ///
  /// Open camera flash.
  openFlash() async {
    AiBarcodeScannerPlatform.instance.openFlash();
  }

  ///
  /// Close camera flash.
  closeFlash() async {
    AiBarcodeScannerPlatform.instance.closeFlash();
  }

  ///
  /// Toggle camera flash.
  toggleFlash() async {
    AiBarcodeScannerPlatform.instance.toggleFlash();
  }
}

///
/// PlatformAiBarcodeCreatorWidget
///
/// Supported android and ios write barcode
// ignore: must_be_immutable
class PlatformAiBarcodeCreatorWidget extends StatefulWidget {
  late CreatorController _creatorController;
  late String _initialValue;
  String? _unsupportedDescription;

  PlatformAiBarcodeCreatorWidget({
    required CreatorController creatorController,
    required String initialValue,
    String? unsupportedDescription,
  }) {
    _creatorController = creatorController;
    _initialValue = initialValue;
    _unsupportedDescription = unsupportedDescription;
  }

  @override
  State<StatefulWidget> createState() {
    return _PlatformAiBarcodeCreatorState();
  }
}

///
/// _PlatformAiBarcodeCreatorState
class _PlatformAiBarcodeCreatorState
    extends State<PlatformAiBarcodeCreatorWidget> {
  @override
  void initState() {
    super.initState();
  }

  _creatorCreatedCallback() {
    if (widget._creatorController._creatorViewCreated != null) {
      widget._creatorController._creatorViewCreated!();
    }
  }

  @override
  void dispose() {
    super.dispose();
    //release
    AiBarcodeCreatorPlatform.instance.removeListener(_creatorCreatedCallback);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        AiBarcodeCreatorPlatform.instance = AiBarcodeMobileCreatorPlugin();
      }
    }
    //create
    AiBarcodeCreatorPlatform.instance.unsupportedPlatformDescription =
        widget._unsupportedDescription;
    AiBarcodeCreatorPlatform.instance.initialValueOfCreator =
        widget._initialValue;
    AiBarcodeCreatorPlatform.instance.addListener(_creatorCreatedCallback);
    return AiBarcodeCreatorPlatform.instance.buildCreatorView(context);
  }
}

///
/// CreatorController
class CreatorController {
  Function()? _creatorViewCreated;

  CreatorController({
    Function()? creatorViewCreated,
  }) {
    _creatorViewCreated = creatorViewCreated;
  }

  void updateValue({
    required String value,
  }) {
    AiBarcodeCreatorPlatform.instance.updateQRCodeValue(value);
  }
}

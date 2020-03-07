part of '../ai_barcode.dart';

///
/// PlatformScannerWidget
///
/// Supported android and ios platform read barcode
// ignore: must_be_immutable
class PlatformAiBarcodeScannerWidget extends StatefulWidget {
  ///
  ///Controller.
  ScannerController _platformScannerController;

  ///
  /// Constructor.
  PlatformAiBarcodeScannerWidget(
      {@required ScannerController platformScannerController}) {
    _platformScannerController = platformScannerController;
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
  /// view id
  String _viewId = "view_type_id_scanner_view";

//  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    //Create
  }

  @override
  void dispose() {
    super.dispose();
    //Release
  }

  @override
  Widget build(BuildContext context) {
    return _cameraView();
  }

  /// Barcode reader widget
  ///
  /// Support android and ios platform barcode reader
  Widget _cameraView() {
    TargetPlatform targetPlatform = Theme.of(context).platform;

    if (targetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: _viewId,
        onPlatformViewCreated: (int id) {
          widget._platformScannerController.scannerViewCreated();
        },
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (targetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _viewId,
        onPlatformViewCreated: (int id) {
          widget._platformScannerController.scannerViewCreated();
        },
        creationParams: <String, dynamic>{},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      return Text("不支持的平台");
    }
  }
}

///
/// PlatformScannerController
class ScannerController {
  ///
  /// Channel
  MethodChannel _methodChannel =
      MethodChannel("view_type_id_scanner_view_method_channel");
//  EventChannel _eventChannel =
//      EventChannel("view_type_id_scanner_view_event_channel");

  ///
  /// Result
  Function(String result) _scannerResult;
  Function() _scannerViewCreated;

  bool _isStartCamera = false;
  bool _isStartCameraPreview = false;
  bool _isOpenFlash = false;

  ///
  /// Constructor.
  ScannerController({
    @required scannerResult(String result),
    scannerViewCreated(),
  }) {
    _scannerResult = scannerResult;
    _scannerViewCreated = scannerViewCreated;
  }

  Function() get scannerViewCreated => _scannerViewCreated;
  bool get isStartCamera => _isStartCamera;
  bool get isStartCameraPreview => _isStartCameraPreview;
  bool get isOpenFlash => _isOpenFlash;

  ///
  /// Start camera without open QRCode、BarCode scanner,this is just open camera.
  startCamera() async {
    _isStartCamera = true;
    _methodChannel.invokeMethod("startCamera");
  }

  ///
  /// Stop camera.
  stopCamera() async {
    _isStartCamera = false;
    _methodChannel.invokeMethod("stopCamera");
  }

  ///
  /// Start camera preview with open QRCode、BarCode scanner,this is open code scanner.
  startCameraPreview() async {
    _isStartCameraPreview = true;
    String code = await _methodChannel.invokeMethod("resumeCameraPreview");
    _scannerResult(code);
  }

  ///
  /// Stop camera preview.
  stopCameraPreview() async {
    _isStartCameraPreview = false;
    _methodChannel.invokeMethod("stopCameraPreview");
  }

  ///
  /// Open camera flash.
  openFlash() async {
    _isOpenFlash = true;
    _methodChannel.invokeMethod("openFlash");
  }

  ///
  /// Close camera flash.
  closeFlash() async {
    _isOpenFlash = false;
    _methodChannel.invokeMethod("closeFlash");
  }

  ///
  /// Toggle camera flash.
  toggleFlash() async {
    bool flash = isOpenFlash;
    _isOpenFlash = !flash;
    _methodChannel.invokeMethod("toggleFlash");
  }
}

///
/// PlatformAiBarcodeCreatorWidget
///
/// Supported android and ios write barcode
// ignore: must_be_immutable
class PlatformAiBarcodeCreatorWidget extends StatefulWidget {
  CreatorController _creatorController;
  String _initialValue;
  PlatformAiBarcodeCreatorWidget({
    @required CreatorController creatorController,
    @required String initialValue,
  }) {
    _creatorController = creatorController;
    _initialValue = initialValue;
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
  /// View id
  static const String _viewId = "view_type_id_creator_view";

  @override
  Widget build(BuildContext context) {
    return _barcodeCreator();
  }

  /// Barcode creator widget
  ///
  /// Supported android and ios platform
  Widget _barcodeCreator() {
    TargetPlatform targetPlatform = Theme.of(context).platform;
    if (targetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: _viewId,
        creationParams: <String, dynamic>{
          "qrCodeContent": widget._initialValue ?? 'please set QRCode value',
        },
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          //created callback
          if (widget._creatorController != null &&
              widget._creatorController._creatorViewCreated != null) {
            widget._creatorController._creatorViewCreated();
          }
          //initial value
          if (widget._creatorController != null) {
            widget._creatorController.updateValue(
              value: widget._initialValue ?? 'please set QRCode value',
            );
          }
        },
      );
    } else if (targetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _viewId,
        creationParams: <String, dynamic>{
          "qrCodeContent": widget._initialValue ?? 'please set QRCode value',
        },
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (int id) {},
      );
    } else {
      return Text("Unsupported platform!");
    }
  }
}

///
/// CreatorController
class CreatorController {
  static const MethodChannel _methodChannel =
      MethodChannel("view_type_id_creator_view_method_channel");

  Function() _creatorViewCreated;

  CreatorController({
    Function() creatorViewCreated,
  }) {
    _creatorViewCreated = creatorViewCreated;
  }

  void updateValue({
    @required String value,
  }) {
    _methodChannel.invokeMethod("updateQRCodeValue", {
      "qrCodeContent": value,
    });
  }
}

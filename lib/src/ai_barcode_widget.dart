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
//  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    //Create
    AiBarcodePlatform.instance.addListener(_widgetCreatedListener);
  }

  ///
  /// CreatedListener.
  _widgetCreatedListener() {
    widget._platformScannerController._scannerViewCreated();
  }

  @override
  void dispose() {
    super.dispose();
    //Release
    AiBarcodePlatform.instance.removeListener(_widgetCreatedListener);
  }

  @override
  Widget build(BuildContext context) {
    return AiBarcodePlatform.instance.buildView(context);
  }
}

///
/// PlatformScannerController
class ScannerController {
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
  startCameraPreview() async {
    _isStartCameraPreview = true;
    String code = await AiBarcodePlatform.methodChannelScanner
        .invokeMethod("resumeCameraPreview");
    _scannerResult(code);
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
    } else {
      return Text("Unsupported platform!");
    }
  }
}

///
/// CreatorController
class CreatorController {
  Function() _creatorViewCreated;

  CreatorController({
    Function() creatorViewCreated,
  }) {
    _creatorViewCreated = creatorViewCreated;
  }

  void updateValue({
    @required String value,
  }) {
    AiBarcodePlatform.methodChannelCreator.invokeMethod("updateQRCodeValue", {
      "qrCodeContent": value,
    });
  }
}

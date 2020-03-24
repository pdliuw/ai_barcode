part of '../ai_barcode.dart';

///
/// PlatformScannerWidget
///
/// Supported android and ios platform read barcode
// ignore: must_be_immutable
class PlatformAiBarcodeScannerWidget extends StatefulWidget {
  ///
  /// Controller.
  ScannerController _platformScannerController;

  ///
  /// UnsupportedDescription
  String _unsupportedDescription;

  ///
  /// Constructor.
  PlatformAiBarcodeScannerWidget({
    @required ScannerController platformScannerController,
    String unsupportedDescription,
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
//  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    //Create
    AiBarcodePlatform.instance.addListener(_widgetCreatedListener);
    AiBarcodePlatform.instance.unsupportedPlatformDescription =
        widget._unsupportedDescription;
  }

  ///
  /// CreatedListener.
  _widgetCreatedListener() {
    if (widget._platformScannerController != null) {
      if (widget._platformScannerController._scannerViewCreated != null) {
        widget._platformScannerController._scannerViewCreated();
      }
    }
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
  bool get isStartCamera => AiBarcodePlatform.instance.isStartCamera;
  bool get isStartCameraPreview =>
      AiBarcodePlatform.instance.isStartCameraPreview;
  bool get isOpenFlash => AiBarcodePlatform.instance.isOpenFlash;

  ///
  /// Start camera without open QRCode、BarCode scanner,this is just open camera.
  startCamera() {
    AiBarcodePlatform.instance.startCamera();
  }

  ///
  /// Stop camera.
  stopCamera() async {
    AiBarcodePlatform.instance.stopCamera();
  }

  ///
  /// Start camera preview with open QRCode、BarCode scanner,this is open code scanner.
  startCameraPreview() async {
    String code = await AiBarcodePlatform.instance.startCameraPreview();
    _scannerResult(code);
  }

  ///
  /// Stop camera preview.
  stopCameraPreview() async {
    AiBarcodePlatform.instance.stopCameraPreview();
  }

  ///
  /// Open camera flash.
  openFlash() async {
    AiBarcodePlatform.instance.openFlash();
  }

  ///
  /// Close camera flash.
  closeFlash() async {
    AiBarcodePlatform.instance.closeFlash();
  }

  ///
  /// Toggle camera flash.
  toggleFlash() async {
    AiBarcodePlatform.instance.toggleFlash();
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

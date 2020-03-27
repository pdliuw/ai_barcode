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
    AiBarcodeScannerPlatform.instance.addListener(_widgetCreatedListener);
    AiBarcodeScannerPlatform.instance.unsupportedPlatformDescription =
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
    AiBarcodeScannerPlatform.instance.removeListener(_widgetCreatedListener);
  }

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScannerPlatform.instance.buildScannerView(context);
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
  CreatorController _creatorController;
  String _initialValue;
  String _unsupportedDescription;
  PlatformAiBarcodeCreatorWidget({
    @required CreatorController creatorController,
    @required String initialValue,
    String unsupportedDescription,
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
    //create
    AiBarcodeCreatorPlatform.instance.unsupportedPlatformDescription =
        widget._unsupportedDescription;
    AiBarcodeCreatorPlatform.instance.initialValueOfCreator =
        widget._initialValue;
    AiBarcodeCreatorPlatform.instance.addListener(_creatorCreatedCallback);
  }

  _creatorCreatedCallback() {
    if (widget._creatorController != null &&
        widget._creatorController._creatorViewCreated != null) {
      widget._creatorController._creatorViewCreated();
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
    return AiBarcodeCreatorPlatform.instance.buildCreatorView(context);
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
    AiBarcodeCreatorPlatform.instance.updateQRCodeValue(value);
  }
}

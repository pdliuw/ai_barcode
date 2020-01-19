part of ai_barcode;

///
/// PlatformScannerWidget
// ignore: must_be_immutable
class PlatformAiBarcodeScannerWidget extends StatefulWidget {
  ///
  ///Controller.
  ScannerController _platformScannerController;

  ///
  /// Constructor.
  PlatformAiBarcodeScannerWidget(
      {@required ScannerController platformScannerController}) {
    this._platformScannerController = platformScannerController;
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
  ///
  /// id
  String _viewId = "view_type_id_scanner_view";

//  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    /*
    Create
     */
  }

  @override
  void dispose() {
    /*
    Release.
     */
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _cameraView();
  }

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
  Function _scannerResult;
  Function _scannerViewCreated;

  bool _isStartCamera = false;
  bool _isStartCameraPreview = false;
  bool _isOpenFlash = false;

  ///
  /// Constructor.
  ScannerController({
    @required scannerResult(String result),
    scannerViewCreated(),
  }) {
    this._scannerResult = scannerResult;
    this._scannerViewCreated = scannerViewCreated;
  }

  get scannerViewCreated => this._scannerViewCreated;
  bool get isStartCamera => this._isStartCamera;
  bool get isStartCameraPreview => this._isStartCameraPreview;
  bool get isOpenFlash => this._isOpenFlash;

  ///
  /// Start camera without open QRCode、BarCode scanner,this is just open camera.
  startCamera() async {
    this._isStartCamera = true;
    _methodChannel.invokeMethod("startCamera");
  }

  ///
  /// Stop camera.
  stopCamera() async {
    this._isStartCamera = false;
    _methodChannel.invokeMethod("stopCamera");
  }

  ///
  /// Start camera preview with open QRCode、BarCode scanner,this is open code scanner.
  startCameraPreview() async {
    this._isStartCameraPreview = true;
    String code = await _methodChannel.invokeMethod("resumeCameraPreview");
    _scannerResult(code);
  }

  ///
  /// Stop camera preview.
  stopCameraPreview() async {
    this._isStartCameraPreview = false;
    _methodChannel.invokeMethod("stopCameraPreview");
  }

  ///
  /// Open camera flash.
  openFlash() async {
    this._isOpenFlash = true;
    _methodChannel.invokeMethod("openFlash");
  }

  ///
  /// Close camera flash.
  closeFlash() async {
    this._isOpenFlash = false;
    _methodChannel.invokeMethod("closeFlash");
  }

  ///
  /// Toggle camera flash.
  toggleFlash() async {
    bool flash = isOpenFlash;
    this._isOpenFlash = !flash;
    _methodChannel.invokeMethod("toggleFlash");
  }
}

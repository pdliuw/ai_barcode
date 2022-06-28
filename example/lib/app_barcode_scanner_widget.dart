import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

late String _label;
late Function(String result) _resultCallback;

///
/// AppBarcodeScannerWidget
class AppBarcodeScannerWidget extends StatefulWidget {
  final bool openManual;

  ///
  ///
  AppBarcodeScannerWidget.defaultStyle({
    Function(String result)? resultCallback,
    this.openManual = false,
    String label = '',
  }) {
    _resultCallback = resultCallback ?? (String result) {};
    _label = label;
  }

  @override
  _AppBarcodeState createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
  bool _isGranted = false;

  bool _useCameraScan = true;

  bool _openManual = false;

  String _inputValue = "";

  @override
  void initState() {
    super.initState();

    _openManual = widget.openManual;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TargetPlatform platform = Theme.of(context).platform;
      if (!kIsWeb) {
        if (platform == TargetPlatform.android ||
            platform == TargetPlatform.iOS) {
          _requestMobilePermission();
        } else {
          setState(() {
            _isGranted = true;
          });
        }
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    });
  }

  void _requestMobilePermission() async {
    bool isGrated = true;
    if (await Permission.camera.status.isGranted) {
      isGrated = true;
    } else {
      if (await Permission.camera.request().isGranted) {
        isGrated = true;
      }
    }
    setState(() {
      _isGranted = isGrated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _isGranted
              ? _useCameraScan
                  ? _BarcodeScannerWidget()
                  : _BarcodeInputWidget.defaultStyle(
                      changed: (String value) {
                        _inputValue = value;
                      },
                    )
              : Center(
                  child: OutlinedButton(
                    onPressed: () {
                      _requestMobilePermission();
                    },
                    child: Text("请求权限"),
                  ),
                ),
        ),
        _openManual
            ? _useCameraScan
                ? OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _useCameraScan = false;
                      });
                    },
                    child: Text("手动输入$_label"),
                  )
                : Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _useCameraScan = true;
                          });
                        },
                        child: Text("扫描$_label"),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _resultCallback(_inputValue);
                        },
                        child: Text("确定"),
                      ),
                    ],
                  )
            : Container(),
      ],
    );
  }
}

class _BarcodeInputWidget extends StatefulWidget {
  late ValueChanged<String> _changed;

  _BarcodeInputWidget.defaultStyle({
    required ValueChanged<String> changed,
  }) {
    _changed = changed;
  }

  @override
  State<StatefulWidget> createState() {
    return _BarcodeInputState();
  }
}

class _BarcodeInputState extends State<_BarcodeInputWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(8)),
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(8)),
            Text(
              "$_label：",
            ),
            Expanded(
              child: TextFormField(
                controller: _controller,
                onChanged: widget._changed,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
          ],
        ),
        Padding(padding: EdgeInsets.all(8)),
      ],
    );
  }
}

///ScannerWidget
class _BarcodeScannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidgetState();
  }
}

class _AppBarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  late ScannerController _scannerController;

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(scannerResult: (result) {
      _resultCallback(result);
    }, scannerViewCreated: () {
      TargetPlatform platform = Theme.of(context).platform;
      if (TargetPlatform.iOS == platform) {
        Future.delayed(Duration(seconds: 2), () {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
      } else {
        _scannerController.startCamera();
        _scannerController.startCameraPreview();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _getScanWidgetByPlatform(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  _scannerController.openFlash();
                },
                child: Text("Open")),
            ElevatedButton(
                onPressed: () {
                  _scannerController.closeFlash();
                },
                child: Text("Close")),
          ],
        ),
      ],
    );
  }

  Widget _getScanWidgetByPlatform() {
    return PlatformAiBarcodeScannerWidget(
      platformScannerController: _scannerController,
    );
  }
}

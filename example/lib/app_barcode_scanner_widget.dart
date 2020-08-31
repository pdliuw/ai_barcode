import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

//import 'package:super_qr_reader/super_qr_reader.dart';

String _label;
Function(String result) _resultCallback;

///
/// AppBarcodeScannerWidget
class AppBarcodeScannerWidget extends StatefulWidget {
  ///
  ///
  AppBarcodeScannerWidget.defaultStyle({
    Function(String result) resultCallback,
    String label = '单号',
  }) {
    _resultCallback = resultCallback ?? (String result) {};
    _label = label;
  }

  @override
  _AppBarcodeState createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
  @override
  Widget build(BuildContext context) {
    return _BarcodePermissionWidget();
  }
}

class _BarcodePermissionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BarcodePermissionWidgetState();
  }
}

class _BarcodePermissionWidgetState extends State<_BarcodePermissionWidget> {
  bool _isGranted = false;

  bool _useCameraScan = true;

  String _inputValue = "";

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  void _requestPermission() async {
    if (await Permission.camera
        .request()
        .isGranted) {
      setState(() {
        _isGranted = true;
      });
    }
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
            child: AppExpandedButtonWidget.defaultStyle(
              onTap: () {
                _requestPermission();
              },
              text: "请求权限",
            ),
          ),
        ),
        _useCameraScan
            ? AppExpandedButtonWidget.defaultStyle(
          onTap: () {
            setState(() {
              _useCameraScan = false;
            });
          },
          text: "手动输入$_label",
          leftFlex: 0,
          rightFlex: 0,
        )
            : AppStickyButtonWidget.defaultStyle(
          beginName: "扫描$_label",
          beginTapCallback: () {
            setState(() {
              _useCameraScan = true;
            });
          },
          endName: "确定",
          endTapCallback: () {
            _resultCallback(_inputValue);
          },
        ),
      ],
    );
  }
}

class _BarcodeInputWidget extends StatefulWidget {
  ValueChanged<String> _changed;

  _BarcodeInputWidget.defaultStyle({
    ValueChanged<String> changed,
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
            AppTextWidget.defaultStyle(
              data: "$_label：",
              textSize: AppTextSize.middle3,
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
  ScannerController _scannerController;

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(scannerResult: (result) {
      _resultCallback(result);
    }, scannerViewCreated: () {
      _scannerController.startCamera();
      _scannerController.startCameraPreview();
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
        MaterialButton(
          onPressed: () {},
          child: Text("哈哈"),
        ),
        Expanded(
          child: _getScanWidgetByPlatform(),
        )
      ],
    );
  }

  Widget _getScanWidgetByPlatform() {
    TargetPlatform targetPlatform = Theme
        .of(context)
        .platform;

    return PlatformAiBarcodeScannerWidget(
      platformScannerController: _scannerController,
    );
  }
}

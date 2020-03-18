import 'package:flutter/material.dart';
import 'package:ai_barcode/ai_barcode.dart';

class TestingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestingState();
  }
}

class _TestingState extends State<TestingPage> {
  ScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = ScannerController(scannerResult: (result) {});
  }

  @override
  void dispose() {
    super.dispose();
    _scannerController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                _scannerController.startCamera();
              },
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("启动相机"),
            ),
            MaterialButton(
              onPressed: () {
                _scannerController.startCameraPreview();
              },
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("启动相机预览"),
            ),
            MaterialButton(
              onPressed: () {
                //停止相机预览
                _scannerController.stopCameraPreview();
              },
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("停止相机预览"),
            ),
            MaterialButton(
              onPressed: () {
                //释放相机
                _scannerController.stopCamera();
              },
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("释放相机"),
            ),
            Container(
              width: 750,
              height: 750,
              child: PlatformAiBarcodeScannerWidget(
                platformScannerController: _scannerController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:ai_barcode_example/full_screen_scanner_page.dart';
import 'package:ai_barcode_example/task_next_page.dart';

import 'package:airoute/airoute.dart';
import 'package:flutter/material.dart';

import 'creator_page.dart';
import 'custom_size_scanner_page.dart';
import 'select_scanner_style_page.dart';

void main() => runApp(
      Airoute.createMaterialApp(
        home: App(),
        routes: <String, WidgetBuilder>{
          "/SelectScannerStylePage": (_) => SelectScannerStylePage(),
          "/CustomSizeScannerPage": (_) => CustomSizeScannerPage(),
          "/FullScreenScannerPage": (_) => FullScreenScannerPage(),
          "/TaskNextPage": (_) => TaskNextPage(),
          "/CreatorPage": (_) => CreatorPage(),
        },
      ),
    );

///
/// App
class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

///
/// _AppState
class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("1D barcode/QR code"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      //跳转页面=扫描二维码
                      Airoute.pushNamed(
                        routeName: "/SelectScannerStylePage",
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("Scan 1D barcode/QR code"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      //跳转页面=生成二维码
                      Airoute.pushNamed(
                        routeName: "/CreatorPage",
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: Text("Create QR code"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

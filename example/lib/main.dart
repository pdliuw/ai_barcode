import 'package:ai_barcode_example/task_next_page.dart';
import 'package:ai_barcode_example/task_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:airoute/airoute.dart';

void main() => runApp(
      Airoute.createMaterialApp(
        home: App(),
        routes: <String, AirouteBuilder>{
          "/TaskScannerPage": () => TaskScannerPage(),
          "/TaskNextPage": () => TaskNextPage(),
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
        title: Text("条码扫描"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            /*
              跳转页面
               */
            Airoute.pushNamed(
              routeName: "/TaskScannerPage",
            );
          },
          textColor: Colors.white,
          color: Colors.blue,
          child: Text("启动相机"),
        ),
      ),
    );
  }
}

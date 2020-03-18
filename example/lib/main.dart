import 'package:ai_barcode_example/task_next_page.dart';
import 'package:ai_barcode_example/task_scanner_page.dart';
import 'package:ai_barcode_example/testing_page.dart';
import 'package:airoute/airoute.dart';
import 'package:flutter/material.dart';

import 'creator_page.dart';

void main() => runApp(
      Airoute.createMaterialApp(
        home: App(),
        routes: <String, WidgetBuilder>{
          "/TaskScannerPage": (_) => TaskScannerPage(),
          "/TaskNextPage": (_) => TaskNextPage(),
          "/CreatorPage": (_) => CreatorPage(),
          "/TestingPage": (_) => TestingPage(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                //跳转页面
                Airoute.pushNamed(
                  routeName: "/TestingPage",
                );
              },
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("测试页面"),
            ),
            MaterialButton(
              onPressed: () {
                //跳转页面=扫描二维码
                Airoute.pushNamed(
                  routeName: "/TaskScannerPage",
                );
              },
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("扫描二维码"),
            ),
            MaterialButton(
              onPressed: () {
                //跳转页面=生成二维码
                Airoute.pushNamed(
                  routeName: "/CreatorPage",
                );
              },
              textColor: Colors.white,
              color: Colors.blue,
              child: Text("生成二维码"),
            ),
          ],
        ),
      ),
    );
  }
}

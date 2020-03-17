import 'package:ai_barcode_example/task_next_page.dart';
import 'package:ai_barcode_example/task_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:airoute/airoute.dart';

import 'creator_page.dart';

void main() => runApp(
      Airoute.createMaterialApp(
        home: App(),
        routes: <String, WidgetBuilder>{
          "/TaskScannerPage": (_) => TaskScannerPage(),
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
        title: Text("条码扫描"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            MaterialButton(
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
            MaterialButton(
              onPressed: () {
                //跳转页面
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

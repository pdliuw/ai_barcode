import 'package:airoute/airoute.dart';
import 'package:flutter/material.dart';

///
/// SelectScannerStylePage
class SelectScannerStylePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectScannerStyleState();
  }
}

///
/// _SelectScannerStyleState
class _SelectScannerStyleState extends State<SelectScannerStylePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Scanner Style"),
      ),
      body: Row(
        children: <Widget>[
          Spacer(),
          Column(
            children: <Widget>[
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Airoute.pushNamed(routeName: "/FullScreenScannerPage");
                },
                child: Text("FullScreen Style"),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Airoute.pushNamed(routeName: "/CustomSizeScannerPage");
                },
                child: Text("CustomSize Style"),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}

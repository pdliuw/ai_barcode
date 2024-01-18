import 'package:ai_barcode_example/app_barcode_scanner_widget.dart';
import 'package:flutter/material.dart';

///
/// FullScreenScannerPage
class FullScreenScannerPage extends StatefulWidget {
  @override
  _FullScreenScannerPageState createState() => _FullScreenScannerPageState();
}

class _FullScreenScannerPageState extends State<FullScreenScannerPage> {
  ValueNotifier<String> _codeNotifier = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String code) {
                _codeNotifier.value = code;
              },
              openManual: false,
            ),
          ),
          Positioned(
            child: Card(
              color: Colors.amber.shade200,
              elevation: 4,
              child: ExpansionTile(
                childrenPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                expandedCrossAxisAlignment: CrossAxisAlignment.end,
                maintainState: true,
                title: ValueListenableBuilder<String>(
                  valueListenable: _codeNotifier,
                  builder: (context, data, child) {
                    return Text(
                      "$data",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                // contents
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: _codeNotifier,
                    builder: (context, data, child) {
                      return Text("$data");
                    },
                  ),
                  // This button is used to remove this item
                ],
              ),
            ),
            left: 0,
            top: 0,
            right: 0,
          ),
        ],
      ),
    );
  }
}

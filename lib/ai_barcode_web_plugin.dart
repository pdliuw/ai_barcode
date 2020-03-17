import 'dart:html';

import 'package:ai_barcode/src/ai_barcode_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

///
/// AiBarcodeWebPlugin
class AiBarcodeWebPlugin extends AiBarcodePlatform {
  /// Registers this class as the default instance of [AiBarcodeWebPlugin].
  static void registerWith(Registrar registrar) {
    AiBarcodePlatform.instance = AiBarcodeWebPlugin();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(AiBarcodePlatform.viewId,
        (int viewId) {
      return LabelElement()..text = "Web端扫码功能，敬请期待";
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return HtmlElementView(viewType: AiBarcodePlatform.viewId);
  }
}

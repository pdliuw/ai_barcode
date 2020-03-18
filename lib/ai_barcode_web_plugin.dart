import 'dart:html' as html;

import 'package:ai_barcode/src/ai_barcode_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

///
/// AiBarcodeWebPlugin
class AiBarcodeWebPlugin extends AiBarcodePlatform {
  ///
  /// VideoElement
  static html.VideoElement _videoElement = html.VideoElement();

  /// Registers this class as the default instance of [AiBarcodeWebPlugin].
  static void registerWith(Registrar registrar) {
    AiBarcodePlatform.instance = AiBarcodeWebPlugin();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(AiBarcodePlatform.viewId,
        (int viewId) {
      return _videoElement;
    });
  }

  @override
  Widget buildView(BuildContext context) {
    //TODO: Waiting complete this.
    Future.delayed(Duration(seconds: 2))
        .then((value) => onPlatformScannerViewCreated(0));
    return HtmlElementView(
      key: UniqueKey(),
      viewType: AiBarcodePlatform.viewId,
    );
  }

  @override
  startCamera() async {
    //start camera
    html.window.navigator
        .getUserMedia(video: true)
        .then((html.MediaStream mediaStream) {
      _videoElement.srcObject = mediaStream;
      return mediaStream;
    });
  }

  @override
  Future<String> startCameraPreview() async {
    //start camera preview
    _videoElement.play();
    return Future.delayed(Duration(seconds: 10))
        .then((value) => "after 10 second ,web code result doing!");
  }

  @override
  stopCameraPreview() async {
    //stop camera preview
    _videoElement.pause();
  }

  @override
  stopCamera() async {
    //stop camera and release camera
    _videoElement.srcObject.getTracks().forEach((element) {
      element.stop();
    });
  }

  @override
  toggleFlash() async {}

  @override
  closeFlash() async {}

  @override
  openFlash() async {}
}

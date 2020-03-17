import Flutter
import UIKit

public class SwiftAiBarcodePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ai_barcode", binaryMessenger: registrar.messenger())
    let instance = SwiftAiBarcodePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)    /*
     Register scanner
     */
    registrar.register(AiBarcodeScannerViewFactory(flutterBinaryMessenger: registrar.messenger()), withId: "view_type_id_scanner_view");
    registrar.register(AiBarcodeCreatorViewFactory(flutterBinaryMessenger: registrar.messenger()), withId: "view_type_id_creator_view");
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

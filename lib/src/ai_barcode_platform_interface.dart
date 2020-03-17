import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ai_barcode_mobile_plugin.dart';

///
/// Channel
const MethodChannel _methodChannelScanner =
    MethodChannel("view_type_id_scanner_view_method_channel");

const MethodChannel _methodChannelCreator =
    MethodChannel("view_type_id_creator_view_method_channel");
//  EventChannel _eventChannel =
//      EventChannel("view_type_id_scanner_view_event_channel");

abstract class AiBarcodePlatform extends ChangeNotifier {
  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements` which is forbidden for anything
  /// other than mocks (see class docs). This property provides a backdoor for mockito mocks to
  /// skip the verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  static String _viewId = "view_type_id_scanner_view";

  static AiBarcodePlatform _instance = AiBarcodeMobilePlugin();

  /// The default instance of [AiBarcodePlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [AiBarcodePlatform] when they
  /// register themselves.
  ///
  static AiBarcodePlatform get instance => _instance;

  ///
  /// ViewId
  static String get viewId => _viewId;

  ///
  /// MethodChannel
  static MethodChannel get methodChannelScanner => _methodChannelScanner;
  static MethodChannel get methodChannelCreator => _methodChannelCreator;

  ///
  /// Instance update
  static set instance(AiBarcodePlatform instance) {
    if (!instance.isMock) {
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = instance;
  }

  /// Returns a widget displaying.
  Widget buildView(BuildContext context) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  ///
  /// View created
  onPlatformScannerViewCreated(int id) {
    notifyListeners();
  }

  // This method makes sure that AiBarcode isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}
}

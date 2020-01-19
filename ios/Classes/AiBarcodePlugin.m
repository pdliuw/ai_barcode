#import "AiBarcodePlugin.h"
#if __has_include(<ai_barcode/ai_barcode-Swift.h>)
#import <ai_barcode/ai_barcode-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ai_barcode-Swift.h"
#endif

@implementation AiBarcodePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAiBarcodePlugin registerWithRegistrar:registrar];
}
@end

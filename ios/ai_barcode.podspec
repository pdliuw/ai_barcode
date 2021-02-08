#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ai_barcode.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ai_barcode'
  s.version          = '0.0.1'
  s.summary          = 'Android and IOS recognize the &quot;one-dimensional bar code&quot; and &quot;two-dimensional bar code&quot;, and support the Scanner embedded in Flutter pages to meet changing business needs'
  s.description      = <<-DESC
Android and IOS recognize the &quot;one-dimensional bar code&quot; and &quot;two-dimensional bar code&quot;, and support the Scanner embedded in Flutter pages to meet changing business needs
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  # (https://github.com/mikebuss/MTBBarcodeScanner)
  s.dependency 'MTBBarcodeScanner'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end

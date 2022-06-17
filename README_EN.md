# ai_barcode

![totem](https://raw.githubusercontent.com/pdliuw/pdliuw.github.io/master/images/totem_four_logo.jpg)

-----

|[English Document](https://github.com/pdliuw/ai_barcode/blob/master/README_EN.md)|[中文文档](https://github.com/pdliuw/ai_barcode)|
|:-|:-|

ai_barcode: Support Android、iOS and web recognition of 'one-dimensional barcode' and 'two-dimensional barcode'

[![pub package](https://img.shields.io/pub/v/ai_barcode.svg)](https://pub.dev/packages/ai_barcode)

Highlights: `` ai_barcode: Support Scanner embedded in flutter pages to meet changing business needs ''

## Effect

|iOS-Scanner|Android-Scanner|
|:-|:-|
|![ios](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_scanner_ios.gif)|![android](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_scanner_android.gif)|
|:-|:-|

|iOS-Creator|Android-Creator|
|:-|:-|
|![ios](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_creator_ios.gif)|![android](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_creator_android.gif)|
|:-|:-|

|Web-Creator|
|:-|
|![web](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_creator_web.gif)|
|:-|

|Web-Scanner|
|:-|
|![web](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_scanner_web.gif)|
|:-|

[ai_barcode](https://github.com/pdliuw/ai_barcode) in[project](https://github.com/flutter-app-sample/flutter_app_sample) practical application [flutter sample](https://github.com/flutter-app-sample/flutter_app_sample)

|[Download Android apk](https://github.com/pdliuw/Flutter_Resource/blob/master/resource/flutter/apk/flutter_scanner.apk?raw=true)|[ios ipa obtained by running the project]()|[Blog web site](https://pdliuw.github.io/)|
|:-|:-|:-|

## 1.Installing

Use this package as a library

### 1. Depend on it

Add this to your package's pubspec.yaml file:

[![pub package](https://img.shields.io/pub/v/ai_barcode.svg)](https://pub.dev/packages/ai_barcode)

```

dependencies:

  ai_barcode: ^version

```

Or depending on

```
dependencies:

  # barcode plugin.
  ai_barcode:
    git:
      url: https://github.com/pdliuw/ai_barcode.git

```

### 2. Install it

You can install packages from the command line:

with Flutter:


```

$ flutter pub get


```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

### 3. Import it

Now in your Dart code, you can use:

```

import 'package:ai_barcode/ai_barcode.dart';


```

## 2.Usage

The use of 'Camera' requires dynamic application permission, dynamic permission recommendation：[permission_handler](https://github.com/Baseflow/flutter-permission-handler)

Configure permissions

Android permission configuration:

```

    <uses-permission android:name="android.permission.CAMERA"/>
    
```

iOS permission configuration:

```

    <key>NSCameraUsageDescription</key>
    <string>Can we access your camera in order to scan barcodes?</string>


```

iOS supports PlatformView configuration:

```
	
    <key>io.flutter.embedded_views_preview</key>
    <true/>
    
```


### 1.Where '1D barcode, 2D barcode' is used:

Brief example

```
                //cameraWidth: the width of the camera; 
                //the height of the cameraHeight camera;
                //which can be dynamically adjusted according to the actual business

                Container(
                  color: Colors.black26,
                  width: cameraWidth,
                  height: cameraHeight,
                  child: PlatformAiBarcodeScannerWidget(
                    platformScannerController: _scannerController,
                  ),
                ),

```

Complete example

[Full example, click here](https://github.com/pdliuw/ai_barcode/blob/master/example/lib/task_scanner_page.dart)


### 2.Call / apply

*1、Turn on the camera device


```

          _scannerController.startCamera();

```
*2、Open Preview / Recognize 'Barcode'


```

          _scannerController.startCameraPreview();

```

*3、Close Preview / Recognize 'Barcode'


```

      _scannerController.stopCameraPreview();

```


*4、Turn off camera equipment


```

      _scannerController.stopCamera();

```

*5、Turn on the flashlight


```

      _scannerController.openFlash();

```

*5、Flashlight off


```

      _scannerController.closeFlash();

```

*5、Toggle flashlight


```

      _scannerController.toggleFlash();

```


Seeing it here is overwhelming？[Click to see project examples](https://github.com/pdliuw/ai_barcode/tree/master/example/lib)

## WEB permissions / security

Access of camera stream is prohibited on unsecured network (http) except for localhost usages.
You can add whiltelist by opening `chrome://flags` and search for `unsafely-treat-insecure-origin-as-secure`

## Thanksgiving


|iOS-Barcode/QRCode Scanner/Creator|Android-Barcode/QRCode Scanner/Creator|Web、MacOS-QrCode Creator|
|:-|:-|:-|
|[Built on: MTBBarcodeScanner](https://github.com/mikebuss/MTBBarcodeScanner)|[Built on: zxing](https://github.com/zxing/zxing)|[Built on: qr_flutter](https://github.com/lukef/qr.flutter)|
|:-|:-|:-|

## TODO


* Support: Camera image can be frozen after successfully scanning barcode on iOS


## LICENSE

    BSD 3-Clause License
    
    Copyright (c) 2020, pdliuw
    All rights reserved.



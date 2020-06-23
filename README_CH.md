# ai_barcode

![totem](https://raw.githubusercontent.com/pdliuw/pdliuw.github.io/master/images/totem_four_logo.jpg)

-----

|[English Document](https://github.com/pdliuw/ai_barcode/blob/master/README_EN.md)|[中文文档](https://github.com/pdliuw/ai_barcode)|
|:-|:-|

ai_barcode:支持Android和IOS识别'一维条码'和'二维条码'的识别

[![pub package](https://img.shields.io/pub/v/ai_barcode.svg)](https://pub.dev/packages/ai_barcode)

亮点: ``ai_barcode:支持在flutter页面中嵌入Scanner以此来应对多变的业务需求``

## Effect

|iOS-Scanner|Android-Scanner|
|:-|:-|
|![ios](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_scanner_ios.gif)|![android](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_scanner_android.gif)|
|:-|:-|

|iOS-Creator|Android-Creator|
|:-|:-|
|![ios](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_creator_ios.gif)|![android](https://github.com/pdliuw/ai_barcode/blob/master/example/gif/flutter_creator_android.gif)|
|:-|:-|

[ai_barcode](https://github.com/pdliuw/ai_barcode) 在[项目](https://github.com/flutter-app-sample/flutter_app_sample)中的实战应用[flutter sample](https://github.com/flutter-app-sample/flutter_app_sample)

|[下载安卓apk安装包](https://github.com/pdliuw/Flutter_Resource/blob/master/resource/flutter/apk/flutter_scanner.apk?raw=true)|[IOS安装包，请下载example后运行项目获取]()|[博客地址](https://pdliuw.github.io/)|
|:-|:-|:-|

## 1.安装

使用当前包作为依赖库

### 1. 依赖此库

在文件 'pubspec.yaml' 中添加

[![pub package](https://img.shields.io/pub/v/ai_barcode.svg)](https://pub.dev/packages/ai_barcode)

```

dependencies:

  ai_barcode: ^version

```

或者以下方式依赖

```
dependencies:

  # barcode package.
  ai_barcode:
    git:
      url: https://github.com/pdliuw/ai_barcode.git

```

### 2. 安装此库

你可以通过下面的命令行来安装此库

```

$ flutter pub get


```

你也可以通过项目开发工具通过可视化操作来执行上述步骤

### 3. 导入此库

现在，在你的Dart编辑代码中，你可以使用：

```

import 'package:ai_barcode/ai_barcode.dart';

```

## 2.使用

使用'相机'需要动态申请权限，动态权限推荐：[permission_handler](https://github.com/Baseflow/flutter-permission-handler)

配置权限

Android权限配置:

```

    <uses-permission android:name="android.permission.CAMERA"/>
    
```

iOS权限配置:

```

    <key>NSCameraUsageDescription</key>
    <string>Can we access your camera in order to scan barcodes?</string>


```

iOS支持PlatformView配置：

```
	
    <key>io.flutter.embedded_views_preview</key>
    <true/>
    
```


### 1.使用'一维条码、二维条码'的地方中：

简要示例

```
                //cameraWidth:相机的宽度;cameraHeight相机的高度,可根据实际的业务来动态调整
                Container(
                  color: Colors.black26,
                  width: cameraWidth,
                  height: cameraHeight,
                  child: PlatformAiBarcodeScannerWidget(
                    platformScannerController: _scannerController,
                  ),
                ),

```

完整示例

[完整示例,点击这里](https://github.com/pdliuw/ai_barcode/blob/master/example/lib/task_scanner_page.dart)


### 2.调用/应用

*1、打开相机设备

```

          _scannerController.startCamera();

```
*2、打开预览/识别'条码'

```

          _scannerController.startCameraPreview();

```

*3、关闭预览/识别'条码'

```

      _scannerController.stopCameraPreview();

```


*4、关闭相机设备

```

      _scannerController.stopCamera();

```

*5、打开手电筒

```

      _scannerController.openFlash();

```

*5、关闭手电筒

```

      _scannerController.closeFlash();

```

*5、切换手电筒

```

      _scannerController.toggleFlash();

```


看到这里还意犹未尽？[点击，查看项目示例](https://github.com/pdliuw/ai_barcode/tree/master/example/lib)

## 待办

* 支持：iOS上成功扫描条形码后也可以冻结相机图像


## LICENSE

    BSD 3-Clause License
    
    Copyright (c) 2020, pdliuw
    All rights reserved.


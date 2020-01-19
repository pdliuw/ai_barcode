import 'package:flutter/material.dart';
import 'package:ai_barcode/ai_barcode.dart';
import 'package:airoute/airoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui';

class TaskScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskScannerPageState();
  }
}

///
/// _TaskScannerPageState
class _TaskScannerPageState extends State<TaskScannerPage>
    with WidgetsBindingObserver {
  ScannerController _scannerController;

  ///
  /// 相机权限的申请状态
  PermissionStatus _permissionStatusCamera;

  @override
  void initState() {
    print("initState");
    /*
    Create.
     */
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _scannerController = ScannerController(
      scannerResult: (String result) {
        setState(
          () {
            /*
            处理扫码结果
             */
            _checkQrCode(result);
          },
        );
      },
      /*
      在组件创建完成后做处理
       */
      scannerViewCreated: () {
        /*
        权限申请
         */
        _checkPermission();
      },
    );
  }

  ///
  /// 此方法在页面首次出现时，不会被调用；只有在'页面熄屏、亮屏'时才会调用
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState:${state}");
    /*
    lifecycle
     */

    if (state == AppLifecycleState.resumed) {
      /*
      在熄灭屏幕可见时会调用此方法，在页面的初始创建时不会调用此方法
       */
      _startCameraPreviewWithPermissionCheck();
    } else if (state == AppLifecycleState.paused) {
      /*
      在熄灭屏幕不可见时会调用此方法，在销毁页面时不会调用此方法
       */
      _stopCameraPreviewWithPermissionCheck();
    } else {
      /*
      Do nothing！
       */
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void deactivate() {
    super.deactivate();
    /*
    跳转下一个A页面会调用此函数
    从上一个A页面返回也会调用此函数
     */
    print("deactivate");
    /*
    切换：相机打开状态、相机预览状态
     */
    _toggleCameraPreviewWithCheckPermission();
  }

  _toggleCameraPreviewWithCheckPermission() {
    if (_cameraGranted()) {
      if (_scannerController.isStartCameraPreview) {
        _scannerController.stopCameraPreview();
      } else {
        _scannerController.startCameraPreview();
      }
    }
  }

  @override
  void dispose() {
    /*
    Release.
     */
    print("dispose");
    _stopCameraPreviewWithPermissionCheck();
    _stopCameraWithPermissionCheck();
    _scannerController = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _checkQrCode(String result) {
    /*
    显示扫描的信息
     */
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("扫码结果"),
          content: Text("扫码结果 : $result"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                _startCameraPreviewWithPermissionCheck();
                Airoute.pop();
              },
              child: Text("知道了"),
            ),
          ],
        );
      },
    );
  }

  bool _cameraGranted() {
    print("_permissionStatusCamera:$_permissionStatusCamera");
    return _permissionStatusCamera == null
        ? false
        : _permissionStatusCamera == PermissionStatus.granted;
  }

  ///
  /// 对于所需权限的处理
  _checkPermission() async {
    _permissionStatusCamera =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (_cameraGranted()) {
      //授权
      _startCameraWithPreviewWithCheckPermission();
    } else {
      //未授权
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("申请权限"),
            content: Text("使用扫码功能需要授权允许使用相机权限"),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Airoute.pop();

                  /*
                  权限申请
                  */
                  _requestPermission();
                },
                child: Text("授权"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  //拒绝将无法使用二维码功能
                  Airoute.pop();
                  _showRequestPermissionSecondVerify();
                },
                child: Text("拒绝"),
              ),
            ],
          );
        },
      );
    }
  }

  _showRequestPermissionSecondVerify() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("再次确认"),
          content: Text("相机权限的申请被拒绝后，将无法使用相机关联的功能！\n\n申请使用相机权限"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Airoute.pop();
                /*
                权限申请
                */
                _requestPermission();
              },
              child: Text("授权"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                //拒绝将无法使用二维码功能
                Airoute.pop();
              },
              child: Text("拒绝"),
            ),
          ],
        );
      },
    );
  }

  _requestPermission() async {
    PermissionGroup cameraPermission = PermissionGroup.camera;
    List<PermissionGroup> permissions = [
      cameraPermission,
    ];
    Map<PermissionGroup, PermissionStatus> result =
        await PermissionHandler().requestPermissions(permissions);
    _permissionStatusCamera = result[cameraPermission];
    if (_cameraGranted()) {
      _startCameraWithPreviewWithCheckPermission();
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("权限被拒"),
            content: Text("申请使用相机权限被拒，导致'无法使用相机功能'。如需使用相机功能？请到设置里打开允许使用相机权限"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("知道了"),
                onPressed: () {
                  Airoute.pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  _startCameraWithPreviewWithCheckPermission() {
    /*
    打开相机、及预览
    */
    if (_cameraGranted()) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        //如果运行在IOS设备上，则延迟打开相机
        Future.delayed(Duration(seconds: 1), () {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
      } else {
        _scannerController.startCamera();
        _scannerController.startCameraPreview();
      }
    }
  }

  ///
  /// 退出当前页面时
  _pop() {
    Airoute.pop();
  }

  _startCameraPreviewWithPermissionCheck() {
    if (_cameraGranted()) {
      _scannerController.startCameraPreview();
    }
  }

  _stopCameraPreviewWithPermissionCheck() {
    if (_cameraGranted()) {
      _scannerController.stopCameraPreview();
    }
  }

  _stopCameraWithPermissionCheck() {
    if (_cameraGranted()) {
      _scannerController.stopCamera();
    }
  }

  _toggleFlashWithCheckPermission() {
    if (_cameraGranted()) {
      _scannerController.toggleFlash();
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("无法使用此功能"),
            content: Text("由于拒绝了应用使用相机的权限，导致无法使用此功能"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("知道了"),
                onPressed: () {
                  Airoute.pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool _isOpenFlashWithCheckPermission() {
    if (_cameraGranted()) {
      return _scannerController.isOpenFlash;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = window.physicalSize;
    double screenWidth = size.width / window.devicePixelRatio;
    double screenHeight = size.height / window.devicePixelRatio;

    double screenWidthSize = screenWidth;
    double cameraWidth = screenWidth;
    double cameraHeight = screenHeight / 5 * 3;

    return Scaffold(
      appBar: null,
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              color: Theme.of(context).primaryColor,
              width: screenWidthSize,
              height: 0,
            ),
          ),
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.black26,
                  width: cameraWidth,
                  height: cameraHeight,
                  child: PlatformAiBarcodeScannerWidget(
                    platformScannerController: _scannerController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: cameraWidth / 8,
                    top: cameraHeight / 5,
                    right: cameraWidth / 8,
                    bottom: cameraHeight / 5,
                  ),
                  width: cameraWidth,
                  height: cameraHeight,
                  child: _recognitionBorder(
                    borderWidth: cameraWidth / 2,
                    borderHeight: cameraHeight / 2,
                  ),
                ),
                //关闭手电筒、退出
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        /*
                        Pop
                         */
                        _pop();
                      },
                      child: Tooltip(
                        message: "",
                        child: Text("退出"),
                      ),
                      textColor: Colors.white,
                    ),
                    MaterialButton(
                      onPressed: () {
                        _toggleFlashWithCheckPermission();
                        setState(() {});
                      },
                      child: Text(
                          "${_isOpenFlashWithCheckPermission() ? "关闭手电筒" : "打开手电筒"}"),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  "这里可以放置需求相关的设计",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    /*
                  页面跳转
                   */
                    Airoute.pushNamed(
                      routeName: "/TaskNextPage",
                    );
                  },
                  child: Text("跳转页面"),
                ),
                Text(
                  "跳转页面，再返回此页面，查看'条形扫码'的生命周期的处理",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// 自定义扫描边框的
  Widget _recognitionBorder({
    @required double borderWidth,
    @required double borderHeight,
  }) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      var lineStrokeWidth = 10.0;
      /*
      识别边框
       */
      return Container(
        width: borderWidth,
        height: borderHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: borderWidth / 3,
                height: lineStrokeWidth,
                color: Colors.green,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: borderWidth / 3,
                color: Colors.green,
                height: lineStrokeWidth,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: borderWidth / 3,
                color: Colors.green,
                height: lineStrokeWidth,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: borderWidth / 3,
                color: Colors.green,
                height: lineStrokeWidth,
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                height: borderHeight / 3,
                color: Colors.green,
                width: lineStrokeWidth,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: borderHeight / 3,
                color: Colors.green,
                width: lineStrokeWidth,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                height: borderHeight / 3,
                color: Colors.green,
                width: lineStrokeWidth,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: borderHeight / 3,
                color: Colors.green,
                width: lineStrokeWidth,
              ),
            ),
          ],
        ),
      );
    } else {
      return Text("");
    }
  }
}

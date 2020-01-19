//
//  AiBarcodeScannerViewFactory.swift
//  ai_barcode
//
//  Created by JamesAir on 2020/1/19.
//

import Foundation

class AiBarcodeScannerViewFactory:NSObject,FlutterPlatformViewFactory{
    
    var binaryMessenger:FlutterBinaryMessenger;
    
    init(flutterBinaryMessenger : FlutterBinaryMessenger) {
    
        binaryMessenger = flutterBinaryMessenger;
    
    }
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return AiBarcodeScannerView(binaryMessenger:binaryMessenger);
    }
}

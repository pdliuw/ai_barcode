//
//  AiBarcodeCreatorViewFactory.swift
//  ai_barcode
//
//  Created by JamesAir on 2020/3/9.
//

import Foundation

class AiBarcodeCreatorViewFactory:NSObject,FlutterPlatformViewFactory{
    
    var binaryMessenger:FlutterBinaryMessenger;
    
    init(flutterBinaryMessenger : FlutterBinaryMessenger) {
    
        binaryMessenger = flutterBinaryMessenger;
    
    }
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return AiBarcodeCreatorView(binaryMessenger:binaryMessenger);
    }
}

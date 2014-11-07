//
//  Utils.swift
//  baige_ios
//
//  Created by test on 14/10/30.
//  Copyright (c) 2014年 test. All rights reserved.
//

import Foundation
import UiKit


//扩展颜色，支持16进制颜色值
extension UIColor{
    
    class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var rgb: CUnsignedInt = 0;
        let scanner = NSScanner(string: hex)
        
        if hex.hasPrefix("#") {
            // skip '#' character
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
extension NSString{
    class func URLEncodeKvString(url:String)
    {
//        newString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, origString, NULL, NULL, kCFStringEncodingUTF8);
//        CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, self,  NULL, ":,", encoding: NSUTF8StringEncoding)
    }
}


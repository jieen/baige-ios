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

extension String {
    var swapcaseString:String {
        var result: String = ""
        for ch in self {
            let s = String(ch)
            result += s.uppercaseString == s ? s.lowercaseString : s.uppercaseString
        }
        return result
    }
    var isUpper:Bool { return self.uppercaseString == self }
    var isLower:Bool { return self.lowercaseString == self }
    var length:Int { return (self as NSString).length }
    var strip:String { return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())}
    var isSpace:Bool { return self.strip == "" }
    var floatValue:Float { return (self as NSString).floatValue }
    var doubleValue:Double { return (self as NSString).doubleValue }
    func count(sub:String) -> Int {
        var result:Int = 0
        var s = self
        let index:String.Index = "a".endIndex
        while s != "" {
            if s.hasPrefix(sub) {
                result += 1
                s = s.substringFromIndex(sub.endIndex)
            } else {
                s = s.substringFromIndex(index)
            }
            
        }
        return result
    }
    func find(sub:String, start:Int = 0, end:Int? = nil) -> Int {
        var s = self as NSString
        var s_temp = s.substringFromIndex(start)
        let end_temp:Int = end != nil ? end! : s.length
        for i in start..<end_temp {
            if (s_temp.hasPrefix(sub)) {
                return i
            }
            s_temp = s.substringFromIndex(i + 1) as NSString
        }
        return -1
    }
    func substring(start:String,end:String?=nil) -> String {
        var i = self.find(start, start: 0, end: nil)
        if i == -1 {
            return self
        }
        if end != nil {
            var j = self.indexAt(i).find(end!, start: 0, end: nil)
            if j == -1 {
                return self.slice(start: i, end: nil)
            }
            return self.slice(start: i, end: j)
        }
        return self.slice(start: i, end: nil)
    }
    func indexAt(i:Int) -> String {
        if i >= 0 {
            return (self as NSString).substringWithRange(NSRange(location: i, length: (self.length-i)))
        }
        let new_i = self.length + i
        return (self as NSString).substringWithRange(NSRange(location: new_i, length: 1))
    }
    func replace(old_str:String, new_str:String) -> String {
        return self.stringByReplacingOccurrencesOfString(old_str, withString: new_str)
    }
    func slice(start:Int=0, end:Int?=nil) -> String {
        let s = self as NSString
        var new_end:Int
        if (end != nil) {
            new_end = end!
        } else {
            new_end = s.length
        }
        return  s.substringWithRange(NSRange(location: start, length:new_end - start))
    }
    func split(sep:String = "") -> [String] {
        var result:[String] = []
        if (sep == "") {
            for ch in self {
                result.append(String(ch))
            }
            return result
        }
        var s:String = self
        var len = sep.length
        var temp:String = ""
        while s != "" {
            if s.hasPrefix(sep) {
                if temp != "" {
                    result.append(temp)
                    temp = ""
                }
                s = s.slice(start: len)
            } else {
                temp += s.slice(start: 0, end: 1)
                s = s.slice(start: 1)
            }
        }
        if temp != "" {
            result.append(temp)
        }
        return result
    }
    var reversed:String { return "".join(self.split().reverse()) }
    func repeat(n:Int) -> String {
        var result:String = ""
        for i in 0..<n {
            result += self
        }
        return result
    }
    func startsWith(s:String) -> Bool {
        return s == self.slice(end: s.length)
    }
    
    func dateStringFromTimestamp(timeStamp:NSString)->String
    {
        var ts = timeStamp.doubleValue
        var  formatter = NSDateFormatter ()
        formatter.dateFormat = "yyyy年MM月dd日 HH:MM:ss"
        var date = NSDate(timeIntervalSince1970 : ts)
        return  formatter.stringFromDate(date)
        
    }
}

func * (left:String, right:Int) -> String{
    return left.repeat(right)
}

func * (left:Int, right:String) -> String{
    return right.repeat(left)
}



extension UIView{
    
    class func showAlertView(title:String,message:String){
        var alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
}



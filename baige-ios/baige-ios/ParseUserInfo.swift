//
//  UserInfoUtils.swift
//  baige-ios
//
//  Created by test on 14/11/10.
//  Copyright (c) 2014年 test. All rights reserved.
//

import Foundation
import UiKit

class ParseUserInfo
{
    class func showAlertMessage(titleStr:String,emsg:String)
    {
        var alertDialog = UIAlertView(title: titleStr, message: emsg, delegate: nil, cancelButtonTitle: "OK")
        alertDialog.show()
    }
    /*解析用户登录*/
    class func ParaseUserLogin(myurl:String,data:AnyObject){
        
//        var emsg = ""
        println("ParaseUserLogin In")
        userid = data.objectForKey("uid") as NSString
        println("uid:\(userid)")
        println("Login In,SessionID:\(sessionid)")
        //登录成功，保存cookie
        var storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        var cookie = NSHTTPCookieStorage.cookiesForURL(storage)(NSURL(string:myurl)!) as [NSHTTPCookie]
        for cokie in cookie{
            sessionid = cokie.value!
            println("SESSIONID:"+sessionid)
        }
        //刷新主界面
        dispatch_async(dispatch_get_main_queue(), {
//            presentModalViewController.OtherController()
//            let mainView = UIStoryboard()
//            let vc:UIViewController = mainView.instantiateViewControllerWithIdentifier("loginsuccess") as UIViewController
//            ctx.presentViewController(vc,animated:true,completion:nil)
//            performSegueWithIdentifier("login", sender: self)
//            Login.jumpToLoginSuccess()
        })
        
    }
    
    /*解析用户注册*/
    class func ParaseUserRegister(myurl:String,data:AnyObject){
//        let retStr = NSString(data: response3, encoding: NSUTF8StringEncoding)
//        println("Response: '\(retStr)'")
//        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(response3, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var emsg = ""
        var ecode: AnyObject? = data.objectForKey("errorcode")
//        var emsg: AnyObject? = json.objectForKey("errormsg")
        println(ecode?.intValue)
        if(ecode?.intValue == 0)
        {
            //注册成功
            var alertView: UIAlertView = UIAlertView(title: "注册成功", message:"注册成功", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
        if let emsg:NSString = data.objectForKey("errormsg") as? NSString{
            //注册失败
            var alertView: UIAlertView = UIAlertView(title: "注册失败", message: emsg, delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
        //刷新主界面
        dispatch_async(dispatch_get_main_queue(), {
//            self.showAlertMessage("注册",emsg:emsg)
        })
    }
    
    /*解析用户注销*/
    class func ParaseUserLogout(){
    
    }
    
}

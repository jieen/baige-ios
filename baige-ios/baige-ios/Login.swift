//
//  Login.swift
//  baige-ios
//  登录界面
//
//  Created by jieen on 14/11/7.
//  Copyright (c) 2014年 test. All rights reserved.
//

import UIKit

class Login : UIViewController {
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassWord: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

//    var timer:NSTimer
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector:"checkUserLogin", userInfo: nil, repeats: true)
    }
    
    func checkUserLogin()->Bool{
        return false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func tfChanged(sender: AnyObject) {
//        println("Text Filed Changed")
        
    }
    
    
    
    //登录事件
    @IBAction func btnLoginClicked(sender: AnyObject) {
        println("btnLogin Clicked")
        if(tfUserName.text == "root"){
            var alertView: UIAlertView = UIAlertView(title: "root?", message: "root is not a valued user", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            return
        }
        if(tfUserName.text.isEmpty || tfPassWord.text.isEmpty)
        {
            //用户名和密码不能为空
            var alertView: UIAlertView = UIAlertView(title: "登录", message: "用户名和密码不能为空", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
//        var ctx = self
//        HttpUtils().checkLogin(tfUserName.text, passwd: tfPassWord.text)
//        //同步
        if(HttpUtils().checkLogin(tfUserName.text,passwd: tfPassWord.text))
        {
            println("login success")
            //跳转到登录成功界面
            self.performSegueWithIdentifier("login", sender: self)
        }
        else
        {
            //登录失败
            var alertView: UIAlertView = UIAlertView(title: "登录失败", message: "请检查网络和用户名,密码信息是否正常", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
    }
}
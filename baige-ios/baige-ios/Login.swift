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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func tfChanged(sender: AnyObject) {
        println("Text Filed Changed")
        
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
        if(HttpUtils().checkLogin(tfUserName.text,passwd: tfPassWord.text))
        {
            println("login success")
            //跳转到登录成功界面
            self.performSegueWithIdentifier("loginSuccess", sender: self)
        }
        else
        {
            //登录失败
            var alertView: UIAlertView = UIAlertView(title: "登录失败", message: "用户名或者密码错误", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
    }
}
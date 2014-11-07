//
//  LoginSuccess.swift
//  baige_ios
//
//  Created by test on 14/11/6.
//  Copyright (c) 2014年 test. All rights reserved.
//

import UiKit

class LoginSuccess : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func logoutClicked(sender: AnyObject) {
//        println("LogoutClicked SessionID:"+sessionid)
        HttpUtils().logOut()
    }
}
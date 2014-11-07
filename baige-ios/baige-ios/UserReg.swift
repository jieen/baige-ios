//
//  UserReg.swift
//  baige_ios
//
//  Created by test on 14/11/6.
//  Copyright (c) 2014年 test. All rights reserved.
//

import UiKit

class UserReg : UIViewController{
    
    @IBOutlet weak var regUser: UITextField!
    @IBOutlet weak var regPasswd: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        btnLogin.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func regBtnClicked(sender: AnyObject) {
        if(regUser.text.isEmpty || regPasswd.text.isEmpty)
        {
            var alert = UIAlertView(title: "User Reg Info", message: "user Name and password must not null", delegate: nil, cancelButtonTitle: nil)
            alert.show()
        }
        HttpUtils().RegUser(regUser.text,passwd: regPasswd.text)
    }
}

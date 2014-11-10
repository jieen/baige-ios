//
//  LoginSuccess.swift
//  baige_ios
//
//  Created by test on 14/11/6.
//  Copyright (c) 2014年 test. All rights reserved.
//

import UiKit

class LoginSuccess : UIViewController{
    
    @IBOutlet weak var tfUname: UITextField!
    @IBOutlet weak var tfOldPwd: UITextField!
    @IBOutlet weak var tfNewPwd: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPostcode: UITextField!
    @IBOutlet weak var tfRecvPeople: UITextField!
    @IBOutlet weak var stOther: UISwitch!
    @IBOutlet weak var tfPicAddr: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func logoutClicked(sender: AnyObject) {
        println("LogoutClicked SessionID:"+sessionid)
        HttpUtils().logOut()
    }
    @IBAction func getInfo(sender: AnyObject) {
        HttpUtils().GetUserInfo()
        
    }
    @IBAction func btnModifyClicked(sender: AnyObject) {
        var user = UserInfo()
        user.uname = tfUname.text
        user.password = tfOldPwd.text
        user.address = tfAddress.text
        user.phone = tfPhone.text
        user.address = tfAddress.text
        user.receivepeople = tfRecvPeople.text
        user.postcode = tfPostcode.text
        user.picaddr = tfPostcode.text
        println("the State is \(stOther.on),OldPwd is \(tfOldPwd.text),NewPwd is \(tfNewPwd.text)")
        if(stOther.on)
        {
            HttpUtils().ModifyPasswd(0, uname: tfUname.text, oldPwd: tfOldPwd.text, newPwd: tfNewPwd.text)
        }else
        {
        
        }
    }
    
    
    
    
}
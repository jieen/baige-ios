//
//  AFHttpUtils.swift
//  baige-ios
//
//  Created by test on 14/11/7.
//  Copyright (c) 2014年 test. All rights reserved.
//

import Foundation
import Alamofire

class AFHttpUtils{
    var serverUrl = "http://10.0.17.246"
    
    func checkLogin(user:String,passwd:String)->()
    {
        let parameters = [
//            "errorcode":"0",
//            "errormsg":"0",
            "data":[
                "uname":user,
                "pwd":passwd
            ]
        ]
        
        Alamofire.request(.POST, serverUrl, parameters: parameters, encoding: .URL)
    }
}
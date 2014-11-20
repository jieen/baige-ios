//
//  MsgReplyUser.swift
//  baige-ios
//
//  Created by test on 14/11/20.
//  Copyright (c) 2014年 test. All rights reserved.
//

import UIKit

class MsgReplyUser: UIViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    
    @IBOutlet weak var tvTitle: UITextField!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        lblUserName.text = msgList[selectId].msgfrom as? String
    }
    
    @IBAction func btnReply(sender: AnyObject) {
        println("reply")
        if(tvTitle.text.isEmpty || tvContent.text.isEmpty){
            println("发送内容不能为空")
            return
        }
        var toUser = msgList[selectId].msgfromid as String
        println(toUser)
        HttpUtils().UserSendNewShortMsg(userid, touid: toUser, subject: tvTitle.text, msg: tvContent.text, replypid: 0)
    }
}
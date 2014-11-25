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
        lblUserName.text = msgList[selectId].authorname as? String
    }
    
    @IBAction func btnReply(sender: AnyObject) {
        println("reply")
        if(tvContent.text.isEmpty){
            println("发送内容不能为空")
            return
        }
        var toUser = msgList[selectId].authorid as String
        var replyid = Int(msgList[selectId].pmid!.integerValue)
        println("toUser:\(toUser),pmid:\(replyid)")
        HttpUtils().UserSendNewShortMsg(userid, touid: toUser, subject: "", msg: tvContent.text, replypid: replyid)
    }
}
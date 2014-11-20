//
//  MsgDetailViewController.swift
//  baige-ios
//
//  Created by test on 14/11/20.
//  Copyright (c) 2014年 test. All rights reserved.
//

import UIKit


class MsgDetailViewController: UIViewController,ReplyUserDelegate {
   
    @IBOutlet weak var lblMsgDetailTitle: UILabel!
    @IBOutlet weak var lblMsgDetailContent: UILabel!
    @IBOutlet weak var lblMsgDetailTime: UILabel!
    @IBOutlet weak var btnMsgDetailSender: UIButton!
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
//        var nib = UINib(nibName:"MsgDetailInfo",bundle:nil)
//        registerNib(nib,forCellReuseIdentifier:"MsgDetail")
        
        println("selectId is \(selectId)")
        var title = msgList[selectId].subject as String
        var content = msgList[selectId].msg as String
        var sender = msgList[selectId].msgfrom as String
        var time = msgList[selectId].dateline as String
        setDetailInfo(title, content: content, sender: sender, time: time)
    }
    
    func setDetailInfo(title:String,content:String,sender:String,time:String){
        lblMsgDetailTitle.text = title
        lblMsgDetailContent.text = content
        lblMsgDetailTime.text = time
        btnMsgDetailSender.setTitle(sender,forState: .Normal)
    }
    
    func ReplyUser() {
        println("Reply User Proto")
        
        self.performSegueWithIdentifier("ReplyID", sender: self)
    }
    
    @IBAction func btnMsgDetailSenderClicked(sender: AnyObject) {
        println("sender")
        
//        var vc = MsgReplyUser(nibName:"MsgDetailInfo",bundle:nil)
        self.performSegueWithIdentifier("ReplyID", sender: self)
    }
}

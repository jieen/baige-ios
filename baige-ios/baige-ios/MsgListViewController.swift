//
//  MsgList.swift
//  baige-ios
//  显示消息列表
//  Created by test on 14/11/13.
//  Copyright (c) 2014年 test. All rights reserved.
//
import UiKit

var selectId = 0

class MsgListViewController:UIViewController,MsgListProtocal{
    
//    var listmsg:Array<MessageInfo> = []
    
    var loginok:LoginSuccess?
    
    override func viewDidLoad() {
        
        loginok?.delegate = self
        
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("did select \(indexPath.row)")
        selectId = indexPath.row
//        var subject = msgList[idx].subject as String
//        var content = msgList[idx].msg as String
//        var sender = msgList[idx].msgfrom as String
//        var time = msgList[idx].dateline as String
        
//        var detailvc = MsgDetailViewController()
//        detailvc.setDetailInfo(subject,content: content,sender: sender,time: time)
        
        self.performSegueWithIdentifier("DetailInfoID", sender: self)
//        var msgDetailVC = MsgDetailViewController()
//        msgDetailVC.setDetailInfo(subject,content: content,sender: sender,time: time)
        
//        loadNibNamed()
//        self.navigationController!.pushViewController(msgDetailVC, animated: false)
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(msgList.count <= 0){
            println(" no Data ")
            return 0
        }
        println(" numberOfRowsInSection \(msgList.count) ")
        return msgList.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("cellForRowAtIndexPath ")
        var nib = UINib(nibName:"MsgListItem",bundle:nil)
        tableView.registerNib(nib,forCellReuseIdentifier:"MsgListItemId")
        var cell:MsgListItemCell = tableView.dequeueReusableCellWithIdentifier("MsgListItemId", forIndexPath: indexPath) as MsgListItemCell
//        cell.setMsgListItemData("title",people: "popo",time: "2014-12-30")
        println(indexPath.row)
        
        /*
            /Users/test/workspace/baige-ios/baige-ios/baige-ios/baige-ios/MsgListViewController.swift:47:52: 'Slice<MessageInfo>' does not have a member named 'msgfrom'
        */
        
        var idx:Int = indexPath.row
        var subject = msgList[idx].subject as String
        var fromUser = msgList[idx].msgfrom as String
        var date = msgList[idx].dateline as String
        
        cell.setMsgListItemData(subject, people: fromUser, time: date)
        println("cellForRowAtIndexPath out")
        return cell
    }
    
    
    func didReceiveMsgList(msglist: Array<MessageInfo>) {
        
        println("didReceiveMsgList")
    }
    
}
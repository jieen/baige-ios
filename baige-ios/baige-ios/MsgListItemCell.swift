//
//  MsgItemCell.swift
//  baige-ios
//
//  Created by test on 14/11/17.
//  Copyright (c) 2014年 test. All rights reserved.
//
import UiKit


protocol ReplyUserDelegate
{
    // @optional func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    
    func ReplyUser()
}

class MsgListItemCell:UITableViewCell{
    
    @IBOutlet weak var lblMsgTitle: UILabel!

    @IBOutlet weak var lblMsgSendTime: UILabel!
    
    @IBOutlet weak var lblUser: UILabel!

    
    var delegate :ReplyUserDelegate!
    
    @IBAction func btnReplyClicked(sender: AnyObject) {
        println("reply")
//        self.delegate.ReplyUser()
    }
    
    
    /*
        /Users/test/workspace/baige-ios/baige-ios/baige-ios/baige-ios/MsgListItemCell.swift:25:37: 
        Cannot convert the expression's type '(IntegerLiteralConvertible, StringLiteralConvertible, $T7)' to type 'IntegerLiteralConvertible'
    */
    @IBAction func btnDelClicked(sender: AnyObject) {
        println("del ,select: \(selectId)")
        var pmids = msgList[selectId].pmid as Int
        println("del pmids:\(pmids)")
        HttpUtils().UserDelShortMsg(0,folder: "inbox",pmids: [pmids])
        
    }
    
    func setMsgListItemData(title:String,people:String,time:String)->(){
        println("setMsgListItemData in")
        lblMsgTitle.text = title
        lblUser.text = people
        //转为时间字符串
//        var date = dateFromString(time)
//        println(date)
        lblMsgSendTime.text = time
    }

}
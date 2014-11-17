//
//  MsgList.swift
//  baige-ios
//  显示消息列表
//  Created by test on 14/11/13.
//  Copyright (c) 2014年 test. All rights reserved.
//

import Foundation
import UiKit

class MsgListViewController:UITableViewController,MsgListProtocal{

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var listmsg:Array<MessageInfo>
    
    override func viewDidLoad() {
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MsgItemId")
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listmsg.count
    }
    
    /*
        /Users/test/workspace/baige-ios/baige-ios/baige-ios/baige-ios/MsgListViewController.swift:36:29: Could not find an overload for 'init' that accepts the supplied arguments
    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MsgItemId", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = listmsg[indexPath.row].uid as? String
//        cell.textLabel.text = "aaaaaa"//+String(listmsg?.count)
        return cell
    }
    
    
    func didReceiveMsgList(msglist: Array<MessageInfo>) {
        listmsg = msglist
        tableView.reloadData()
        println(listmsg[0].uid)
        
//        self.tableView.dataSource = listmsg[0] as NSDictionary
//        tableView.reloadData()
    }
    
}
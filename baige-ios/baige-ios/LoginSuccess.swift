//
//  LoginSuccess.swift
//  baige_ios
//
//  Created by test on 14/11/6.
//  Copyright (c) 2014年 test. All rights reserved.
//

import UiKit


protocol MsgListProtocal{
    func didReceiveMsgList(msglist:Array<MessageInfo>)
}

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
    @IBOutlet weak var tfMsgToUser: UITextField!
    @IBOutlet weak var tfMsgContent: UITextField!
    @IBOutlet weak var tfMsgTitle: UITextField!
    
    var delegate:MsgListProtocal?
    
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
        var ret = false
        var user = UserInfo()
        user.uname = tfUname.text
        user.password = tfOldPwd.text
        user.address = tfAddress.text
        user.phone = tfPhone.text
        user.receivepeople = tfRecvPeople.text
        user.postcode = tfPostcode.text
        user.picaddr = tfPicAddr.text

        if(stOther.on)
        {
            println("the State is \(stOther.on),OldPwd is \(tfOldPwd.text),NewPwd is \(tfNewPwd.text)")
            ret = HttpUtils().ModifyPasswd(0, uname: tfUname.text, oldPwd: tfOldPwd.text, newPwd: tfNewPwd.text)
        }
        else
        {
            ret = HttpUtils().ModifyOther(0, phone: user.phone!, address: user.address!, recvman: user.receivepeople!, postcode: user.postcode!, picaddr: user.picaddr!)
        }
        //修改信心提示
        var alertView: UIAlertView = UIAlertView(title: "修改提示", message: ret ? "修改信息成功" : "修改信息失败", delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    //成都市新创路28号 金网通
    func validateValueIsNumber(codeStr:NSString) -> Bool {
      return false
    }
    @IBAction func btnGetUserClicked(sender: AnyObject) {
        var user = HttpUtils().GetUserInfo()
//        println(user.authname?+user.phone?+user.postcode?)
        tfUname.text = user.uname
        tfAddress.text = user.address
        tfPhone.text = user.phone
        tfPostcode.text = user.postcode
        tfRecvPeople.text = user.receivepeople
        tfPicAddr.text = user.picaddr
        tfOldPwd.text = user.password
    }
    
    /*
        {
            "errorcode":"0",
            "errormsg":"获取消息列表成功",
            "data":
                {
                    "count":1,
                    "data":
                        [
                            {
                                "plid":"1",
                                "uid":"9",
                                "isnew":"1",
                                "pmnum":"2",
                                "lastupdate":"0",
                                "lastdateline":"1415694571",
                                "authorid":"11",
                                "pmtype":"1",
                                "subject":"my title",
                                "members":"2",
                                "dateline":"1415694571",
                                "lastmessage":"",
                                "touid":"11",
                                "founddateline":"1415694518",
                                "pmid":"1",
                                "lastauthorid":"11",
                                "lastauthor":"test1",
                                "msgfromid":"11",
                                "msgfrom":"test1",
                                "message":"my content",
                                "new":"1",
                                "msgtoid":"11",
                                "daterange":"2",
                                "tousername":"test1"
                            }
                        ]
                }
        }
    
    */
    
    
    //获取纸条列表
    @IBAction func btnGetMsgListClicked(sender: AnyObject) {
        var listmi = HttpUtils().UserGetShortMsgList(0, page: 1, pagesize: 10, folder: "inbox", filter: "newpm", msglen: 0)
        if(listmi.isEmpty){
            println("list is empty")
            return
        }
        if(listmi.count > 0){
            println("get msg list success count: \(listmi.count)")
            for index in 0...listmi.count-1
            {
                
//                var mi:MessageInfo? = listmi[index]
                var plid: AnyObject? = listmi[index].plid
                println("Cur: \(index) , plid: \(plid)")
                var plidInt = Int(plid!.integerValue)
                var pmids = HttpUtils().UserGetShortMsgBySessionId(0, plid: plidInt)
                if(pmids.count <= 0){
                    println("no pmids found")
                    continue
                }
                for i in 0...pmids.count-1 {
                    /*
                    /Users/test/workspace/baige-ios/baige-ios/baige-ios/baige-ios/LoginSuccess.swift:144:48: 'Int32' is not convertible to 'Int'
                    
                    */
                    
//                    var pmididx:Int = Int(pmids[i] as NSNumber)
                    println("Cur \(i) pmid : \(pmids[i])")
                    /*
                    /Users/test/workspace/baige-ios/baige-ios/baige-ios/baige-ios/LoginSuccess.swift:151:33: Cannot invoke 'init' with an argument list of type '($T4, pmid: @lvalue Int)'
                    
                    */
//                    var pmidInt = pmids[i] as? Int
                    var pmidInt = Int(pmids[i].integerValue)
                    
                    println("Cur \(i) pmidInt : \(pmidInt)")
                    
                    HttpUtils().UserGetShortMsgContent(0, pmid: pmidInt)
                }
            }
            
            for num in 0...msgList.count-1 {
                println("subject: \(msgList[num].subject) msg: \(msgList[num].msg)")
            }
            
            delegate?.didReceiveMsgList(listmi)
            self.performSegueWithIdentifier("MSGLISTID", sender: self)
        }else
        {
            println("No msg or get list error")
        }
    }
    
    //检查是否有新纸条
    @IBAction func btnCheckNewMsgClicked(sender: AnyObject) {
        var ret = HttpUtils().UserHasNewShortMsg(0)
        if(ret){
            println("Has New Message")
        }
        else
        {
            println("No New Message")
        }
    }
    
    //发送纸条
    @IBAction func btnSendMsgClicked(sender: AnyObject) {
        if(tfMsgToUser.text.isEmpty || tfMsgContent.text.isEmpty || tfMsgTitle.text.isEmpty){
            println("发送的用户和内容不能为空")
            return
        }
        HttpUtils().UserSendNewShortMsg(userid, touid: tfMsgToUser.text, subject: tfMsgTitle.text, msg: tfMsgContent.text, replypid: 0)
    }
    
    
}
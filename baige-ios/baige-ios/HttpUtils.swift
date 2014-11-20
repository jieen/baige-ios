//
//  HttpUtils.swift
//  baige_ios
//
//  Created by test on 14/10/30.
//  Copyright (c) 2014年 test. All rights reserved.
//

import Foundation
import UiKit

var userid="0"
var sessionid="0"

var syncType = 1

var msgList = Array<MessageInfo>()



class HttpUtils{
//    var ServerUrl = "http://10.0.16.246:8080"
    var ServerUrl = "http://baigeapp.duapp.com"
//    var ServerUrl = "http://10.0.17.189"
    enum USER_TYPE:Int{
        case LOGIN,REGISTER,LOGOUT,GETUSERINFO
    }
    
    /**
        冒号和逗号转换
        ：  %0x3A+
        ,   %0x2c
    */
    func urlEncode(base:String,oriString:String)->String{
        println(oriString)
        var tmpStr = oriString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        tmpStr = tmpStr?.stringByReplacingOccurrencesOfString(":", withString: "%3A")
        tmpStr = tmpStr?.stringByReplacingOccurrencesOfString(",", withString: "%2C")
        return base + tmpStr!
    }
    func urlEncodeArray(base:String,oriString:String)->String{
        println(oriString)
        var tmpStr = oriString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        tmpStr = tmpStr?.stringByReplacingOccurrencesOfString(":", withString: "%3A")
        tmpStr = tmpStr?.stringByReplacingOccurrencesOfString(",", withString: "%2C")
        tmpStr = tmpStr?.stringByReplacingOccurrencesOfString("(", withString: "%5B")
        tmpStr = tmpStr?.stringByReplacingOccurrencesOfString(")", withString: "%5D")
        return base + tmpStr!
    }
    
    //异步post
    func PostJSONDataAsync(myUrl:String,rawData:AnyObject,type:USER_TYPE)->(){
//        var type = 0;
        var url = NSURL(string : myUrl)
        let request = NSMutableURLRequest(URL: url!)
        println("sessionID is \(sessionid)")
//        request.setValue("sessionid=" + sessionid,forHTTPHeaderField: "Cookie")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        var data = rawData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
//        println(data)
        request.HTTPBody = data
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {
                response,data,error in
                var errMsg = " "
                if (error != nil){
                    println("\(error)")
                }else
                {
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    var errCode: AnyObject? = json.objectForKey("errorcode")
                    errMsg = json.objectForKey("errormsg") as String
                    println("errCode: \(errCode) errMsg: \(errMsg)")
                    if(errCode == nil || errMsg.isEmpty || errCode?.integerValue != 0){
                        //刷新主界面
                        dispatch_async(dispatch_get_main_queue(), {
                            var alertDialog = UIAlertView(title: "提示", message: errMsg, delegate: nil, cancelButtonTitle: "OK")
                            alertDialog.show()
                        })
                        return
                    }
                    var data: AnyObject? = json.objectForKey("data")
                    switch(type)
                    {
                    case .LOGIN:
                        println("LOGIN TYPE")
                        ParseUserInfo.ParaseUserLogin(myUrl,data:data!)
                        break;
                    case .REGISTER:
                        ParseUserInfo.ParaseUserRegister(myUrl,data: data!)
                        break;
                    case .LOGOUT:
                        ParseUserInfo.ParaseUserLogout()
                        break;
                    default:
                        break;
                    }
                    if(errCode?.intValue == 0){
                        println("login success")
                        
                    }else
                    {
                        println("login failed")
                    }
                }
            })
        }
    /*
        POST 原始数据
    */
    func PostJSONData(myUrl:String,rawData:AnyObject)->NSData{
        var url = NSURL(string : myUrl)
        let request = NSMutableURLRequest(URL: url!)
        println("sessionID is \(sessionid)")
        request.setValue("sessionid=" + sessionid,forHTTPHeaderField: "Cookie")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.timeoutInterval = 3
        var data = rawData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
//        println(data)
        request.HTTPBody = data
        var respose:NSData!
        //同步
        respose = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if(respose == nil)
        {
            println("nil")
            return "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        }
        return respose
    }
    
    /*
        0sh25c9gfu7cohic4mmcbii4c3
        SESSIONID:0sh25c9gfu7cohic4mmcbii4c3
        SESSIONID:4EE5917A8AEADA23F6FACBEAFE32C347:FG=1
        SESSIONID:0sh25c9gfu7cohic4mmcbii4c3
    */
    func checkLogin(user:String,passwd:String)->Bool{
        if(syncType == 1)
        {
            println("SYNC")
            var ret = checkLoginSync(user,passwd: passwd)
            return ret
        }else
        {
            println("user is \(user) and passwd is \(passwd)")
            var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uname\":\"\(user)\",\"pwd\":\"\(passwd)\"}}"
            var baseStr:String = "content="
            var rawDataStr = urlEncode(baseStr,oriString: dataIn)
            //println(rawDataStr)
            println("SESSIONID: "+sessionid)
            PostJSONDataAsync(ServerUrl+"/tipsbar/login/",rawData: rawDataStr,type: .LOGIN)
            return true
        }
        
    }
    //登录处理
    func checkLoginSync(user:String,passwd:String)->Bool{
        println("user is \(user) and passwd is \(passwd)")
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uname\":\"\(user)\",\"pwd\":\"\(passwd)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        //println(rawDataStr)
        println("SESSIONID: "+sessionid)
        var myUrl = ServerUrl+"/tipsbar/login/"
        if(syncType == 1)
        {
            
            var response3 = PostJSONData(myUrl,rawData: rawDataStr)
            if(response3.length <= 0)
            {
                return false
            }
            var storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            var cookie = NSHTTPCookieStorage.cookiesForURL(storage)(NSURL(string:ServerUrl+"/tipsbar/login/")!) as [NSHTTPCookie]
            for cokie in cookie{
                //            println(cokie.name+" : "+cokie.value!)
                sessionid = cokie.value!
                println("SESSIONID:"+sessionid)
            }
            let retStr = NSString(data: response3, encoding: NSUTF8StringEncoding)
            println("Response: '\(retStr)'")
            var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(response3, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            var ecode: AnyObject? = json.objectForKey("errorcode")
            println(ecode?.intValue)
            if(ecode?.intValue == 0)
            {
                var emsg: AnyObject? = json.objectForKey("errormsg")
                var data = json.objectForKey("data") as NSDictionary
                userid = data.valueForKey("uid") as NSString
                println("ecode: \(ecode),emsg:\(emsg),uid:\(userid)")
                println("Login In,SessionID:\(sessionid)")
                return true
            }
            return false
        }else
        {
            PostJSONDataAsync(myUrl, rawData: rawDataStr, type: .LOGIN)
//            return false
        }
        return false
    }
    
    func saveCookie(serUrl:String){
        println("save cookie in")
        var cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(fileURLWithPath: serUrl)!) as [NSHTTPCookie]
        for cookie in cookies
        {
            println(cookie.value)
            if cookie.name == "sessionid"{
                sessionid = cookie.value!
                println("Login In,SessionID:\(sessionid)")
            }
        }
    }
    
    func isLogined()->Bool{
        var storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        var cookie = NSHTTPCookieStorage.cookiesForURL(storage)(NSURL(string:ServerUrl+"/tipsbar/login/")!)
        if(cookie?.count > 0)
        {
            println("cookie save ok")
            return true
        }else
        {
            println("Can't save cookie")
            return false
        }
    }
    
    func checkLogin2(user:String,passwd:String)->Bool{

        println("user is \(user) and passwd is \(passwd)")
        var data:[String:AnyObject] = ["content":["errorcode":0,"errormsg":0,"data":["uname":user,"pwd":passwd]]]
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uname\":\"\(user)\",\"pwd\":\"\(passwd)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        println(rawDataStr)
        post(data, url: ServerUrl+"/tipsbar/login/") {
            (succeeded: Bool, msg: String) -> () in
            var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
            if(succeeded) {
                alert.title = "Success!"
                alert.message = msg
            }
            else {
                alert.title = "Failed :("
                alert.message = msg
            }
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Show the alert
                alert.show()
            })
        }
        
        
//        PostJSONData2(ServerUrl+"/tipsbar/login/",jsonData: rawDataStr)
        
//        
//        var respose =  PostJSONData1(ServerUrl+"/tipsbar/login/",jsonData: rawDataStr)
//        if(respose.length <= 0)
//            {
//                return false
//            }
//            let retStr = NSString(data: respose, encoding: NSUTF8StringEncoding)
//            println("Response: '\(retStr)'")
        
        
        
        
//            var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
//    //        if(json != nil){
//                var errorcode:AnyObject! = json.objectForKey("errorcode")
//                var errormsg: AnyObject!  = json.objectForKey("errormsg")
//                println("errorcode is \(errorcode),errormsg is \(errormsg)")
        
            
    //            if(errorcode as NSNumber == 0){
    //                var data:NSDictionary! = json.objectForKey("data") as NSDictionary
    //                userid = data.objectForKey("uid") as Int
    //                sessionid = 111111
                    return true
    //            }
    //        }
       return false
    }
    //注册处理
    func RegUser(user:String,passwd:String)->(){
        
        println("user is \(user) and passwd is \(passwd)")
        //      var data = ["errorcode":0,"errormsg":0,"data":["uname":user,"pwd":passwd]]
        
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uname\":\"\(user)\",\"pwd\":\"\(passwd)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        println(rawDataStr)
        var myUrl = ServerUrl+"/tipsbar/register/"
        
        if(syncType == 1)
        {
            var response3 = PostJSONData(myUrl,rawData: rawDataStr)
        
            if(response3.length <= 0)
            {
                return
            }
            let retStr = NSString(data: response3, encoding: NSUTF8StringEncoding)
            println("Response: '\(retStr)'")
            var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(response3, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            var ecode: AnyObject? = json.objectForKey("errorcode")
            println(ecode?.intValue)
            if(ecode?.intValue == 0)
            {
                //注册成功
                var alertView: UIAlertView = UIAlertView(title: "注册成功", message:"注册成功", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
                return
            }
            if let emsg:NSString = json.objectForKey("errormsg") as? NSString{
                //注册失败
                var alertView: UIAlertView = UIAlertView(title: "注册失败", message: emsg, delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
            return
        }else
        {
//            PostJSONDataAsync(myUrl,rawData: rawDataStr,type: .REGISTER)
        }
    }
    //退出
    func logOut()->(){
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid]]
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\"\(userid)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        var myUrl:NSString = ServerUrl+"/tipsbar/logout/"
//        println(rawDataStr)
        if(syncType == 1)
        {
            var response3 = PostJSONData(myUrl,rawData: rawDataStr)
            if(response3.length <= 0)
            {
                return
            }
            let retStr = NSString(data: response3, encoding: NSUTF8StringEncoding)
            println("Response: '\(retStr)'")
            var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(response3, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            var ecode: AnyObject? = json.objectForKey("errorcode")
            println(ecode?.intValue)
            if(ecode?.intValue == 0)
            {
                var alert = UIAlertView(title: "退出登录", message: "退出登录成功", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            var alert = UIAlertView(title: "退出登录", message: "退出登录失败", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }else
        {
//            PostJSONDataAsync(ctx,myUrl,rawData: rawDataStr,type: .LOGOUT)
        }
    }
    //用户信息
    func GetUserInfo()->UserInfo{
        
        var user = UserInfo()
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid]]
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\"\(userid)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        
        var myUrl = ServerUrl+"/tipsbar/userinfo/get/"
        if(syncType == 1)
        {
            println("GetUserInfo in")
            var respose = PostJSONData(myUrl,rawData: rawDataStr)
            var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
            
            println(json)
            var errorcode:AnyObject! = json.objectForKey("errorcode")
            println("errorcode: \(errorcode)")
            var errormsg: AnyObject!  = json.objectForKey("errormsg")
            if(errorcode.intValue == 0){
//                var user = UserInfo()
                var data = json.objectForKey("data") as NSDictionary
                user.uid = data.objectForKey("uid") as? String
                user.uname = data.objectForKey("uname") as? String
                user.phone = data.objectForKey("phone") as? String
                user.address = data.objectForKey("address") as? String
                user.authid = data.objectForKey("authid") as? String
                user.authname = data.objectForKey("authname") as? String
                user.picaddr = data.objectForKey("picaddr") as? String
                user.postcode = data.objectForKey("postcode") as? String
                user.receivepeople = data.objectForKey("receivepeople") as? String
                println("id: \(user.uid),name:\(user.uname),phone: \(user.phone)")
                return user
            }
            return user
        }else
        {
//            PostJSONDataAsync(myUrl, rawData: rawDataStr, type: .GETUSERINFO)
        }
        return user
    }
    //修改用户密码
    func ModifyPasswd(uid:Int,uname:String,oldPwd:String,newPwd:String)->Bool
    {
        println("user is \(uid)")
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid,"uname":uname,"oldpwd":oldPwd,"newpwd":newPwd]]
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\"\(userid)\",\"uname\":\"\(uname)\",\"oldpwd\":\"\(oldPwd)\",\"newpwd\":\"\(newPwd)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        var respose = PostJSONData(ServerUrl+"/tipsbar/userinfo/update/password.php",rawData: rawDataStr)
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
        
        var errorcode:AnyObject! = json.objectForKey("errorcode")
        var errormsg: AnyObject!  = json.objectForKey("errormsg")
        if(errorcode.intValue == 0){
            println("Modify Password OK")
            return true
        }
        println("Modify Password Failed")
        return false
    }
    //修改用户其他信息
    func ModifyOther(uid:Int,phone:String,address:String,recvman:String,postcode:String,picaddr:String)->Bool
    {
        println("user is \(uid)")
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid,"phone":phone,"address":address,"receivepeople":recvman,"postcode":postcode,"picaddr":picaddr]]
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\"\(userid)\",\"phone\":\"\(phone)\",\"address\":\"\(address)\",\"receivepeople\":\"\(recvman)\",\"postcode\":\"\(postcode)\",\"picaddr\":\"\(picaddr)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        var respose = PostJSONData(ServerUrl+"/tipsbar/userinfo/update/other.php",rawData: rawDataStr)
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
        
        var errorcode:AnyObject! = json.objectForKey("errorcode")
        var errormsg: AnyObject!  = json.objectForKey("errormsg")
        if(errorcode.intValue == 0){
            println("Modify Other Success")
            return true
        }
        println("errorcode: \(errorcode),msg: \(errormsg)")
        println("Modify Other Failed")
        return false
    }
    //是否有小纸条
    func UserHasNewShortMsg(uid:Int)->Bool
    {
        println("user is \(uid)")
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid]]
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\"\(userid)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        var respose = PostJSONData(ServerUrl+"/tipsbar/usermsg/checknew/",rawData: rawDataStr)
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        var errorcode:AnyObject! = json.objectForKey("errorcode")
        var errormsg: AnyObject!  = json.objectForKey("errormsg")
        if(errorcode.intValue == 0){
            var data = json.objectForKey("data") as NSDictionary
            var hasnew = data.objectForKey("hasnew") as Int
            if(hasnew == 1){
                return true
            }
            else{
                return false
            }
        }
        return false
    }
    //发送短消息
    func UserSendNewShortMsg(fromuid:String,touid:String,subject:String,msg:String,replypid:Int)->Bool
    {
        println("user is \(fromuid)")
        
//        var data = ["errorcode":0,"errormsg":0,"data":["fromuid":fromuid,"sendtoid":touid,"subject":subject,"msg":msg,"replypid":replypid]]
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"fromuid\":\"\(fromuid)\",\"sendtoid\":\"\(touid)\",\"subject\":\"\(subject)\",\"msg\":\"\(msg)\",\"replypid\":\"\(replypid)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        
        var respose = PostJSONData(ServerUrl+"/tipsbar/usermsg/sendmsg/",rawData: rawDataStr)
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
        
        var errorcode:AnyObject! = json.objectForKey("errorcode")
        var errormsg: AnyObject!  = json.objectForKey("errormsg")
        if(errorcode.intValue == 0){
            var data = json.objectForKey("data") as NSDictionary
            var lasted: AnyObject? = data.objectForKey("lasted")
            println("the lasted msg id is: \(lasted)")
            return true
        }
        return false
    }
    //删除短消息
    func UserDelShortMsg(uid:Int,folder:String,pmids:NSArray)->Bool
    {
        println("user is \(uid)")
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid,"folder":folder,"pmids":[pmids]]]
        
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\"\(userid)\",\"folder\":\"\(folder)\",\"pmids\":\(pmids)}}"
        var baseStr:String = "content="
//        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        var rawDataStr = urlEncodeArray(baseStr,oriString: dataIn)
        
       println(rawDataStr)

        var respose = PostJSONData(ServerUrl+"/tipsbar/usermsg/delmsg/",rawData: rawDataStr)
//        var respose = PostJSONData(ServerUrl+"/tipsbar/usermsg/delmsg/",rawData: baseStr)
        
        //test code start
        var str = NSString(data:respose,encoding:NSUTF8StringEncoding)
        println(str)
        //test code end
        
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
        
        var errorcode:AnyObject! = json.objectForKey("errorcode")
        var errormsg: AnyObject!  = json.objectForKey("errormsg")
        if(errorcode.intValue == 0){
            var data = json.objectForKey("data") as NSDictionary
            var delcount: AnyObject? = data.objectForKey("delcount")
            println("del msg number is \(delcount)")
            return true
        }else{
            println("del msg error")
            return false
        }
    }
    
    
    
    /*
    1.0
    {
    "errorcode":"0",
    "errormsg":"获取消息列表成功",
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
    "daterange":"1",
    "tousername":"test1"
    }
    ]
    }
    1.1
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
    //获取短消息列表
    func UserGetShortMsgList(uid:Int,page:Int,pagesize:Int,folder:String,filter:String,msglen:Int)->Array<MessageInfo>
    {
        println("user is \(userid)")
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid,"page":page,"pagesize":pagesize,"folder":folder,"filter":filter,"msglen":msglen]]
        
        
        var shortMsgList = Array<MessageInfo>()
    
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\(userid),\"page\":\(page),\"pagesize\":\(pagesize),\"folder\":\"\(folder)\",\"filter\":\"\(filter)\",\"msglen\":\(msglen)}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
    
        var respose = PostJSONData(ServerUrl+"/tipsbar/usermsg/getlist/",rawData: rawDataStr)
        
        //test code start
        var str = NSString(data:respose,encoding:NSUTF8StringEncoding)
        println(str)
        //test code end

        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    
        var errorcode:AnyObject! = json.objectForKey("errorcode")
        var errormsg: AnyObject!  = json.objectForKey("errormsg")

        if(errorcode.intValue == 0){
            var data: AnyObject? = json.objectForKey("data")
            if((data?.isEqual(NSNull)) == nil){
                println(" no data ")
                return []
            }

            var realData = json.objectForKey("data") as NSDictionary
            var count = realData.objectForKey("count") as Int
            println("The msg Count is \(count)")
            var subData = realData.objectForKey("data") as NSArray
            var msgCount = count
            if(count != subData.count){
                msgCount = ( count > subData.count ) ? count : subData.count
            }
            if(msgCount <= 0){
                println("no msg")
                return []
            }
            for index in 0...msgCount-1 {
                
                println("index: \(index)")
                var mi = MessageInfo()
                mi.plid = subData[index].objectForKey("plid")
                mi.uid = subData[index].objectForKey("uid")
                mi.isnew = subData[index].objectForKey("isnew")
                mi.pmid = subData[index].objectForKey("pmid")
                mi.msgfrom = subData[index].objectForKey("msgfrom")
                mi.msgfromid = subData[index].objectForKey("msgfromid")
                mi.msgtoid = subData[index].objectForKey("msgtoid")
                mi.hasnew = subData[index].objectForKey("new")
                mi.subject = subData[index].objectForKey("subject")
                mi.dateline = subData[index].objectForKey("dateline")
                mi.msg = subData[index].objectForKey("message")
                mi.daterange = subData[index].objectForKey("daterange")
                
                shortMsgList.append(mi)
                println("msg info: uid: \(mi.uid),list.uid: \(shortMsgList[index].uid)")
                
            }
        }
        return shortMsgList
    }
    //根据会话id获取消息id
    func UserGetShortMsgBySessionId(uid:Int,plid:Int)->NSArray
    {
        println("user is \(userid)")
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid,"plid":plid]]
        
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\"\(userid)\",\"plid\":\"\(plid)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        
        
        var respose = PostJSONData(ServerUrl+"/tipsbar/usermsg/getpmids/",rawData: rawDataStr)
        
        //test code start
        var str = NSString(data:respose,encoding:NSUTF8StringEncoding)
        println(str)
        //test code end
        
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
        
        var errorcode:AnyObject! = json.objectForKey("errorcode")
        var errormsg: AnyObject!  = json.objectForKey("errormsg")
        if(errorcode.intValue == 0){
            var pmid = json.objectForKey("data") as NSArray
            if(pmid.count <= 0){
                println("data is null")
                return []
            }
//            var plid: AnyObject? = data.objectForKey("pmid")
//            println("the msg id is \(plid)")
//            var pmid = data.objectForKey("pmid") as NSArray
            println("pm items count is \(pmid.count),the pmid[0] is \(pmid[0])")
            return pmid
        }
        return NSArray()
    }
    
    
    
    /*
        {
            "errorcode":"0",
            "errormsg":"获取消息内容成功",
            "data":[
                    {
                        "plid":"3",
                        "authorid":"14",
                        "pmtype":"1",
                        "subject":"mu14",
                        "members":"2",
                        "dateline":"1416275327",
                        "pmid":"8",
                        "message":"141414141414",
                        "founderuid":"14",
                        "founddateline":"1416275327",
                        "touid":"9",
                        "author":"test2",
                        "msgfromid":"14",
                        "msgfrom":"test2",
                        "msgtoid":"9"
                    }
                 ]
        }
    
    
    */
    //获取短消息内容
    func UserGetShortMsgContent(uid:Int,pmid:Int)->Array<MessageInfo>
    {
        println("user is \(uid)")
//        var data = ["errorcode":0,"errormsg":0,"data":["uid":uid,"pmid":pmid]]
        
        var dataIn = "{\"errorcode\":0,\"errormsg\":0,\"data\":{\"uid\":\"\(userid)\",\"pmid\":\"\(pmid)\"}}"
        var baseStr:String = "content="
        var rawDataStr = urlEncode(baseStr,oriString: dataIn)
        
        var respose = PostJSONData(ServerUrl+"/tipsbar/usermsg/getmsg/",rawData: rawDataStr)
        
        //test code start
        var str = NSString(data:respose,encoding:NSUTF8StringEncoding)
        println(str)
        //test code end
        
        
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
        
        var errorcode:AnyObject! = json.objectForKey("errorcode")
        var errormsg: AnyObject!  = json.objectForKey("errormsg")
        
        if(errorcode.intValue == 0){
            var data = json.objectForKey("data") as NSArray
            if(data.count <= 0){
                println("Can't found data'")
                return []
            }
            println(data.count)
            for idx in 0...data.count-1 {
                var mi = MessageInfo()
                mi.plid = data[idx].objectForKey("plid")
//                var plid: AnyObject? = data[idx].objectForKey("plid")
                println("the msg id is \(mi.plid)")
                mi.authorid = data[idx].objectForKey("authorid")
                mi.pmtype = data[idx].objectForKey("pmtype")
                mi.members = data[idx].objectForKey("members")
                mi.pmid = data[idx].objectForKey("pmid")
                mi.founderuid = data[idx].objectForKey("founderuid")
                mi.founddateline = data[idx].objectForKey("founddateline")
                mi.author = data[idx].objectForKey("author")
                mi.msgfromid = data[idx].objectForKey("msgfromid")
                mi.touid = data[idx].objectForKey("touid")
                mi.msgfrom = data[idx].objectForKey("msgfrom")
                mi.msgtoid = data[idx].objectForKey("msgtoid")
                mi.subject = data[idx].objectForKey("subject")
                mi.dateline = data[idx].objectForKey("dateline")
                mi.msg = data[idx].objectForKey("message")
                msgList.append(mi)
            }
            return msgList
        }
        return msgList
    }
    
    func GetData(myUrl:String)
    {
        createRequest(myUrl,type:"GET",params:nil,completion:
            {
                (returnedObject:AnyObject?,error:NSError?) in
                if (returnedObject != nil){
                    println("data = \(returnedObject)")
                }
                println("Http Get over")
            }
        )
    }
    
    func PostJSONData2(myUrl:String,jsonData:AnyObject)->(){
        createRequest(myUrl,type:"POST",params:jsonData as? NSDictionary,completion:
            {
                (returnedObject:AnyObject?,error:NSError?) in
                if (returnedObject != nil){
                    println("data = \(returnedObject)")
                }
                println("Http post over")
            }
        )
        
    }
   
    
    
    
    
    
    
    //同步post数据 http post data sync
    func PostJSONData1(myUrl:String,jsonData:AnyObject)->NSData{
            var url = NSURL(string : myUrl)
            let request = NSMutableURLRequest(URL: url!)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.HTTPMethod = "POST"
            let postData = NSJSONSerialization.dataWithJSONObject(jsonData, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            request.HTTPBody = postData//"content={\"errorcode\":\"0\",\"errormsg\":\"0\",\"data\":{\"uname\":\"asda\",\"pwd\":\"aab\"}}".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)//jsonData as? NSData
            var respose:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
            return respose
    }
    
    
    //创建http请求，支持Get和Post
    func createRequest(myUrl:String,type:String,params:NSDictionary?,completion:(AnyObject?,NSError?)->Void){
        var url = NSURL(string:myUrl)
        println("The Url is : \(url)")
        var request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60.0)
        if (params != nil){
            var data = NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            
            var strJson = NSString(data: data!, encoding: NSUTF8StringEncoding)
            println("strjson is \(strJson)")
            var postdata = "content="+strJson!
            println("postdata is \(postdata)")
            
            request.setValue("\(data?.length)", forHTTPHeaderField: "Content-Length")
            request.setValue("keep-alive", forHTTPHeaderField: "Connection")
            request.HTTPBody = postdata.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = type
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!) in
            if (error != nil){
                println("error http : \(error)")
            }else
            {
                var json:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                println("the json is \(json)")
 
                var errCode: AnyObject? = json.objectForKey("errorcode")
                var errMsg:AnyObject? = json.objectForKey("errormsg")
                println("errCode: \(errCode) errMsg: \(errMsg)")
                if(errCode == nil || errMsg == nil){
                    return
                }
                if(errCode as Int == 0){
                    println("Return success")
                }
            }
            //刷新主界面
            dispatch_async(dispatch_get_main_queue(), {
                
            })
            
            
        })
            
//            var str = NSString(data:data,encoding:NSUTF8StringEncoding)
//            println(str)
            println("ooovvvveeeeerrrrrrr")
            
//            var returnedObject:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
//            completion(returnedObject,error)
            
            
//        })
        println("The Url is  Over")
    }
    
    //检测登录是否成功,异步网络请求处理
    func checkLoginisSuccess(userName:String?,userPwd:String?)->Bool
    {
        var ret = false;
        //        let url = "http://10.0.17.189:8080/1.json"
        let url = "http://www.x-lifes.com/AndroidApk/CloudHome/Upgrade.json"
        var request = NSURLRequest(URL: NSURL(string: url)!)
        println("\(url)")
        var loadData	 = NSOperationQueue()
        //同步方法
        //NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        //异步数据处理
        NSURLConnection.sendAsynchronousRequest(request, queue: loadData, completionHandler: {
            response,data,error in
            if (error != nil){
                println("\(error)")
            }else
            {
                var json:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                var errCode: AnyObject? = json.objectForKey("errorcode")
                var errMsg:AnyObject? = json.objectForKey("errormsg")
                println("errCode: \(errCode) errMsg: \(errMsg)")
                if(errCode == nil || errMsg == nil){
                    return
                }
                if(errCode as Int == 0){
                    println("login success")
                    
                }else
                {
                    ret = false
                }
            }
            //刷新主界面
            dispatch_async(dispatch_get_main_queue(), {
                
            })
            
            
        })
       
        return ret
    }
    
    
    
    func loadweather(){
        
        var url = NSURL(string: "http://www.weather.com.cn/data/sk/101010100.html")
        var request = NSURLRequest(URL: url!)
        var respose:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(respose, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
        
        var theweather: NSDictionary = json.objectForKey("weatherinfo") as NSDictionary
        var city: AnyObject!  = theweather.objectForKey("city")
        var temp:AnyObject! = theweather.objectForKey("temp")
        var wd:AnyObject! = theweather.objectForKey("WD")
        var ws:AnyObject! = theweather.objectForKey("WS")
        var time:AnyObject! = theweather.objectForKey("time")
        println("城市：\(city)\n 温度：\(temp)\n 风向：\(wd)\n风级：\(ws)\n 时间：\(time)")
    }
    
    func toJSONString(dict:NSDictionary)->String{
        var data = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted ,  error: nil)
        var strJson = NSString(data: data!, encoding: NSUTF8StringEncoding)
        return strJson!
    }
    
    func post(params : Dictionary<String, AnyObject>, url : String, postCompleted : (succeeded: Bool, msg: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        var postBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.HTTPBody = postBody
        
        var postBodyStr = NSString(data: postBody!, encoding: NSUTF8StringEncoding)
        println("Post Body Str is \(postBodyStr)")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("GBK,utf-8", forHTTPHeaderField: "Accept-Charset")
        request.addValue("zh-CN,zh", forHTTPHeaderField: "Accept-Language")
//        request.addValue("160", forHTTPHeaderField: "Content-Length")
        request.addValue("zh-CN,zh", forHTTPHeaderField: "User-Agent")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var jsonResponse:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &err) as NSDictionary
            
            var msg = "No message"
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg: "Error")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("not parse JSON: \(jsonStr)")
                var errcode: AnyObject? = jsonResponse.objectForKey("errorcode")
                if(errcode as NSNumber == 0){
                    println("success")
                }else
                {
                    println("failed")
                }
        
//
//                if let parseJSON = json {
//                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
//                    if let success = parseJSON["success"] as? Bool {
//                        println("Succes: \(success)")
//                        postCompleted(succeeded: success, msg: "Logged in.")
//                    }
//                    return
//                }
//                else {
//                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
//                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                    println("Error could not parse JSON: \(jsonStr)")
//                    postCompleted(succeeded: false, msg: "Error")
//                }
            }
        })
        
       task.resume()
    }
    
}
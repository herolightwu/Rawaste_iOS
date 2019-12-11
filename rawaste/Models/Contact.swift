//
//  Contact.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/16/19.
//

import UIKit


class Contact: NSObject {
    public var cid = ""
    public var message = ""
    public var type:Int = 0
    public var timestamp:Int64 = 0
    public var user:User = me
    public var unread_count:Int = 0
        
    public func dic_value() -> [String:Any] {
        let param:[String:Any] = [
            "id": cid,
            "message": message,
            "type": type,
            "timestamp": timestamp,
            "user": user.dic_value(),
            "unread_count": unread_count
        ]        
        return param
    }
    convenience init(dic:[String:AnyObject]) {
        self.init()
        
        if let id = dic["id"] as? String { self.cid = id }
        if let msg = dic["message"] as? String { self.message = msg }
        if let ty = dic["type"] as? Int { self.type = ty }
        if let ts = dic["timestamp"] as? Int64 { self.timestamp = ts }
        if let user = dic["user"] as? [String:AnyObject] { self.user = User(dic: user) }
        if let uncount = dic["unread_count"] as? Int { self.unread_count = uncount }
    }
}


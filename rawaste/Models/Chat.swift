//
//  Chat.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/16/19.
//

import UIKit


class Chat: NSObject {
    public var cid = ""
    public var sender = ""
    public var message = ""
    public var type:Int = 0
    public var timestamp:Int64 = 0
        
    public func dic_value() -> [String:Any] {
        let param:[String:Any] = [
            "id": cid,
            "sender": sender,
            "message": message,
            "type": type,
            "timestamp": timestamp
        ]
        
        return param
    }
    convenience init(dic:[String:AnyObject]) {
        self.init()
        
        if let id = dic["id"] as? String { self.cid = id }
        if let sd = dic["sender"] as? String { self.sender = sd }
        if let msg = dic["message"] as? String { self.message = msg }
        if let ty = dic["type"] as? Int { self.type = ty }
        if let ts = dic["timestamp"] as? Int64 { self.timestamp = ts }
        
    }
}

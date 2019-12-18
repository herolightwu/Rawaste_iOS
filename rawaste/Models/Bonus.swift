//
//  Bonus.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/25/19.
//

import UIKit

class Bonus: NSObject {
    public var amount = 0
    public var oId = ""
    public var uId = ""
    public var ts:Int64 = 0
        
    public func dic_value() -> [String:Any] {
        let param:[String:Any] = [
            "amount": amount,
            "OID": oId,
            "UID": uId,
            "timestamp": ts
        ]
        
        return param
    }
    convenience init(dic:[String:AnyObject]) {
        self.init()
        
        if let eb = dic["amount"] as? Int { self.amount = eb }
        if let eb_ts = dic["timestamp"] as? Int64 { self.ts = eb_ts }
        if let eu = dic["OID"] as? String { self.oId = eu }
        if let eu_ts = dic["UID"] as? String { self.uId = eu_ts }
        
    }
}

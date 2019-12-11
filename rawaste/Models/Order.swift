//
//  Order.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/16/19.
//

import UIKit

class Order: NSObject {
    public var oId = ""
    public var sId = ""
    public var bId = ""
    public var pId = ""
    public var apartment = ""
    public var street = ""
    public var city = ""
    public var country = ""
    public var phone = ""
    public var pincode = ""
    public var delivery = ""
    public var type:Int = 0
    public var count:Int = 0
    public var subtotal:Double = 0
    public var tax:Double = 0
    public var total:Double = 0
    public var status:Int = 1
    public var timestamp:Int64 = 0
    
    public func dic_value() -> [String:Any] {
        let param:[String:Any] = [
            "ID": oId,
            "SID": sId,
            "BID": bId,
            "PID": pId,
            "apartment": apartment,
            "street": street,
            "city": city,
            "country": country,
            "phone_number": phone,
            "pincode": pincode,
            "delivery": delivery,
            "type": type,
            "count": count,
            "subtotal": subtotal,
            "tax": tax,
            "time_stamp": timestamp,
            "status": status,
            "total": total
        ]
        
        return param
    }
    convenience init(dic:[String:AnyObject]) {
        self.init()
        
        if let id = dic["ID"] as? String { self.oId = id }
        if let sid = dic["SID"] as? String { self.sId = sid }
        if let bid = dic["BID"] as? String { self.bId = bid }
        if let pid = dic["PID"] as? String { self.pId = pid }
        if let apart = dic["apartment"] as? String { self.apartment = apart }
        if let ct = dic["country"] as? String { self.country = ct }
        if let st = dic["street"] as? String { self.street = st}
        if let city = dic["city"] as? String { self.city = city }
        if let phone = dic["phone_number"] as? String { self.phone = phone }
        if let pincode = dic["pincode"] as? String { self.pincode = pincode }
        if let delivery = dic["delivery"] as? String { self.delivery = delivery }
        if let type = dic["type"] as? Int { self.type = type }
        if let count = dic["count"] as? Int { self.count = count }
        if let sub = dic["subtotal"] as? Double { self.subtotal = sub }
        if let tax = dic["tax"] as? Double { self.tax = tax }
        if let ts = dic["timestamp"] as? Int64 { self.timestamp = ts }
        if let st = dic["status"] as? Int { self.status = st }
        if let total = dic["total"] as? Double { self.total = total }
        
    }
    
}

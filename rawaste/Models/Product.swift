//
//  Product.swift
//  Flashhop
//
//  Created by Jinri on 2019/9/24.
//

import UIKit
import SDWebImage


class Product: NSObject {
    public var pId = ""
    public var uId = ""
    public var name = ""
    public var desc = ""
    public var email = ""
    public var country = ""
    public var country_name = ""
    public var city = ""
    public var phone = ""
    public var country_code = ""
    public var pay_type:Int = 0
    public var price:Double = 0
    public var bonus_chain:Int = 0
    public var interest_exchange:Int = 0
    public var time_stamp:Int64 = 0
    public var status:Int = 1
    public var images:[String] = []
    
    public func dic_value() -> [String:Any] {
        let param:[String:Any] = [
            "ID": pId,
            "UID": uId,
            "name": name,
            "description": desc,
            "email": email,
            "country": country,
            "country_name": country_name,
            "city": city,
            "phone": phone,
            "country_code": country_code,
            "payment_type": pay_type,
            "price": price,
            "bonus_chain": bonus_chain,
            "interest_exchange": interest_exchange,
            "time_stamp": time_stamp,
            "status": status,
            "images": images
        ]
        
        return param
    }
    convenience init(dic:[String:AnyObject]) {
        self.init()
        
        if let id = dic["ID"] as? String { self.pId = id }
        if let uid = dic["UID"] as? String { self.uId = uid }
        if let name = dic["name"] as? String { self.name = name }
        if let desc = dic["description"] as? String { self.desc = desc }
        if let email = dic["email"] as? String { self.email = email }
        if let ct = dic["country"] as? String { self.country = ct }
        if let ct_name = dic["country_name"] as? String { self.country_name = ct_name}
        if let city = dic["city"] as? String { self.city = city }
        if let phone = dic["phone"] as? String { self.phone = phone }
        if let ct_code = dic["country_code"] as? String { self.country_code = ct_code }
        if let ptype = dic["payment_type"] as? Int { self.pay_type = ptype }
        if let pr = dic["price"] as? Double { self.price = pr }
        if let bc = dic["bonus_chain"] as? Int { self.bonus_chain = bc }
        if let ie = dic["interest_exchange"] as? Int { self.interest_exchange = ie }
        if let ts = dic["time_stamp"] as? Int64 { self.time_stamp = ts }
        if let st = dic["status"] as? Int { self.status = st }
        if let imgs = dic["images"] as? [String] {
            //for i in 0..<imgs.count {
            //    self.images.append(imgs[i]!)
            //}
            self.images = imgs
        }
        
    }
    
    /*func saveAsDraft() {
        var dic = dic_value()
        if self.db_id == 0 {
            dic["db_id"] = Int(Date().timeIntervalSince1970)
        } else{
            removeFromDraft()
        }
        var array = UserDefaults.standard.array(forKey: "draft_events") ?? []
        array.append(dic)
        UserDefaults.standard.set(array, forKey: "draft_events")
    }
    func removeFromDraft() {
        var array = UserDefaults.standard.array(forKey: "draft_events") as? [[String:AnyObject]] ?? []
        array = array.filter({ (dic) -> Bool in
            let event = Event(dic: dic)
            return event.db_id != self.db_id
        })
        UserDefaults.standard.set(array, forKey: "draft_events")
    }*/
}
/*func draft_events() -> [Event] {
    var events:[Event] = []
    let dicArray = UserDefaults.standard.array(forKey: "draft_events") as? [[String:AnyObject]] ?? []
    for dic in dicArray {
        let event = Event(dic: dic)
        events.append(event)
    }
    return events
}*/

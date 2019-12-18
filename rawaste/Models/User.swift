//
//  User.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/10/19.
//

import UIKit

class User: NSObject {
    public var uId:String = ""
    public var facebookID:String = ""
    public var googleID:String = ""
    public var email:String = ""
    public var firstname:String = ""
    public var lastname:String = ""
    public var type:String = "Individual"  //"Company"
    public var phone:String = ""
    public var country_code:String = ""
    public var duns:String = ""
    public var activity_area:String = ""
    public var type_waste:String = ""
    public var online:Bool = false
    public var latitude:Double = 0.0
    public var longitude:Double = 0.0
    public var photo:String = ""
    public var balance:Double = 0.0
    public var bonuschain:Int = 0
    public var product_count:Int = 0
    public var review:Int = 0
    public var evaluation:Int = 0
    public var privateKey:String = ""
    public var publicKey:String = ""
    public var address:String = ""
    
    public func dic_value() -> [String:Any] {
        let param:[String:Any] = [
            "ID": uId,
            "facebookID": facebookID,
            "googleID": googleID,
            "email": email,
            "firstname": firstname,
            "lastname": lastname,
            "type": type,
            "phone": phone,
            "country_code": country_code,
            "duns": duns,
            "activity_area": activity_area,
            "type_waste": type_waste,
            "online": online,
            "latitude": latitude,
            "longitude": longitude,
            "photo": photo,
            "balance": balance,
            "bonuschain": bonuschain,
            "product_count": product_count,
            "review": review,
            "evaluation": evaluation,
            "privateKey": privateKey,
            "publicKey": publicKey,
            "address": address
        ]
        
        return param
    }
    convenience init(dic:[String:AnyObject]) {
        self.init()
        
        if let id = dic["ID"] as? String { self.uId = id }
        if let fid = dic["facebookID"] as? String { self.facebookID = fid }
        if let gid = dic["googleID"] as? String { self.googleID = gid }
        if let email = dic["email"] as? String { self.email = email }
        if let fname = dic["firstname"] as? String { self.firstname = fname }
        if let lname = dic["lastname"] as? String { self.lastname = lname}
        if let ty = dic["type"] as? String { self.type = ty }
        if let phone = dic["phone"] as? String { self.phone = phone }
        if let ct_code = dic["country_code"] as? String { self.country_code = ct_code }
        if let duns = dic["duns"] as? String { self.duns = duns }
        if let area = dic["activity_area"] as? String { self.activity_area = area }
        if let wtype = dic["type_waste"] as? String { self.type_waste = wtype }
        if let online = dic["online"] as? Bool { self.online = online }
        if let lat = dic["latitude"] as? Double { self.latitude = lat }
        if let lng = dic["longitude"] as? Double { self.longitude = lng }
        if let imgs = dic["photo"] as? String { self.photo = imgs }
        if let bal = dic["balance"] as? Double { self.balance = bal }
        if let bchain = dic["bonuschain"] as? Int { self.bonuschain = bchain }
        if let pcount = dic["product_count"] as? Int { self.product_count = pcount }
        if let review = dic["review"] as? Int { self.review = review }
        if let ev = dic["evaluation"] as? Int { self.evaluation = ev }
        if let ppkey = dic["privateKey"] as? String { self.privateKey = ppkey }
        if let pkey = dic["publicKey"] as? String { self.publicKey = pkey }
        if let addr = dic["address"] as? String { self.address = addr }
    }
}

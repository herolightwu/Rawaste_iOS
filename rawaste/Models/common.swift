//
//  common.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/16/19.
//

import UIKit

var me = User()

let IS_LOGINED = "is_logined"
let LOGIN_EMAIL = "login_email"
let LOGIN_PASS = "login_password"

let FIREBASE_USER = "User"
let FIREBASE_EMAIL = "email"
let FIREBASE_PRODUCT = "Product"
let FIREBASE_FAVORITE = "Favorite"
let FIREBASE_CART = "Cart"
let FIREBASE_SUBSCRIBER = "Subscriber"
let FIREBASE_SUBSCRIPTION = "Subscription"
let FIREBASE_ORDER = "Order"
let FIREBASE_CONTACT = "Contact"
let FIREBASE_CHAT = "Chat"
let FIREBASE_BONUSCHAIN = "Bonuschain"
let FIREBASE_PURCHASE = "Purchase"
let FIREBASE_SALE = "Sale"
let FIREBASE_TIMESTAMP = "timestamp"
let FIREBASE_TEXT = 0
let FIREBASE_IMAGE = 1

let SERVER_ADDRESS = "0x034825e120bb83af33c93c9eef0dd77ba8fd108e"
let SERVER_PRIVATE_KEY = "104796639170737302935174682745466016675743504127254983758937663549549839418030"
let SERVER_PUBLIC_KEY = "1013312342043906984872075895796517223221990186610564928878603591809760449339996986741823026241678552748080078520279766275379201360001283409845864202320018"

let ADDRESS_ISSAVED = "address_issaved"
let ADDRESS_APARTMENT = "address_apartment"
let ADDRESS_STREET = "address_street"
let ADDRESS_CITY = "address_city"
let ADDRESS_COUNTRY = "address_country"
let ADDRESS_COUNTRY_CODE = "address_country_code"
let ADDRESS_PHONE_CODE = "address_phone_code"
let ADDRESS_PHONE = "address_phone"
let ADDRESS_PINCODE = "address_pincode"

func isValidEmail(_ emailStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let trimmedString = emailStr.trimmingCharacters(in: .whitespacesAndNewlines)
    return emailPred.evaluate(with: trimmedString)
}

func putString(_ key:String, val: String) {
    UserDefaults.standard.setValue(val, forKey: key)
}
func getString(_ key:String) -> String {
    let str = UserDefaults.standard.string(forKey: key) ?? ""
    return str
}

func showAlert (parent:UIViewController, title:String, msg:String) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    parent.present(alert, animated: true, completion: nil)
}

func deltaTimeString (_ delta: Int64) -> String {
    let min = delta/60 as Int64
    let hour = min/60 as Int64
    let day = hour/24 as Int64
    if day > 30 {
        return ""
    }
    if day > 0 {
        return "\(day) days ago"
    }
    if hour > 0 {
        return "\(hour) hours ago"
    }
    if min == 0 {
        return "now"
    }
    return "\(min) mins ago"
}

func getChatID(_ a: User, b: User) -> String {
    if a.uId.compare(b.uId) == .orderedAscending {
        return "room" + a.uId + "_" + b.uId
    } else{
        return "room" + b.uId + "_" + a.uId
    }
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let rc = CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
    let label:UILabel = UILabel(frame: rc)
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text

    label.sizeToFit()
    return label.frame.height
}


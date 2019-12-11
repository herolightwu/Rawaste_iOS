//
//  ApiManager.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/18/19.
//

import UIKit
import Alamofire
import KRProgressHUD
import Firebase

class APIManager {
    static var plist:[Product] = []
    static var ulist:[User] = []
    class func checkCart(uid: String, pid: String, result: @escaping (Bool)->Void){
        let ref = Database.database().reference()
        KRProgressHUD.show()
        ref.child(FIREBASE_CART).child(uid).queryOrderedByKey().queryEqual(toValue: pid).observeSingleEvent(of: .value, with: {(snapshot) in
            KRProgressHUD.dismiss()
            if snapshot.hasChildren() {
                result(true)
            } else {
                result(false)
            }
        })
    }
    class func getCartWithUID(uid: String, result: @escaping ([Product])->Void) {
        let ref = Database.database().reference()
        KRProgressHUD.show()
        ref.child(FIREBASE_CART).child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            KRProgressHUD.dismiss()
            if snapshot.hasChildren() {
                var ids : [String] = []
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    ids.insert(sh.key, at: 0)
                }
                plist.removeAll()
                getProductList(ids: ids, ind: 0, result1: { data_result in
                    result(data_result)
                })
            }
        })
    }
    
    class func getProductList(ids:[String], ind:Int, result1: @escaping ([Product])->Void){
        if ind == ids.count {
            result1(plist)
            return
        }
        getProductWithUID(pid: ids[ind]){ prdata in
            plist.append(prdata)
            getProductList(ids: ids, ind: ind + 1, result1: result1)
        }
    }
    
    class func getProductWithUID(pid: String,result: @escaping (Product)->Void) {
        let ref = Database.database().reference()
        ref.child(FIREBASE_PRODUCT).queryOrderedByKey().queryEqual(toValue: pid).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChildren() {
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let pr = Product.init(dic:sh.value as! Dictionary)
                    result(pr)
                    return
                }
            }
        })
    }
    
    class func getAllProductsWithUID(uid: String,result: @escaping ([Product])->Void) {
        let ref = Database.database().reference()
        KRProgressHUD.show()
        ref.child(FIREBASE_PRODUCT).queryOrdered(byChild: "UID").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: {(snapshot) in
            KRProgressHUD.dismiss()
            var pr_list:[Product] = []
            if snapshot.hasChildren() {
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let pr = Product.init(dic:sh.value as! Dictionary)
                    if pr.status == 1 {
                        pr_list.insert(pr, at: 0)
                    }
                }
            }
            result(pr_list)
        })
    }
    
    class func getTokenBalances(addr: String, result: @escaping (Double)->Void, error:@escaping (String)->Void){
        let url = "http://api.ethplorer.io/getAddressInfo/" + addr + "?apiKey=freekey"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                if let value = response.result.value as? [String:AnyObject] {
                    if let val = value["ETH"] as? [String: AnyObject]{
                        let ret_d = val["balance"] as! Double
                        result(ret_d)
                    }else{
                        error("No result")
                    }
                } else{
                    error("Json parse error")
                }
        }
    }
    
    class func getEtherPrice(result: @escaping (Price)->Void, error:@escaping (String)->Void){
        let url = "http://api.etherscan.io/api?module=stats&action=ethprice"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                if let value = response.result.value as? [String:AnyObject] {
                    if let val = value["result"] as? [String: AnyObject]{
                        let ret_d = Price.init(dic: val)
                        result(ret_d)
                    }else{
                        error("No result")
                    }
                } else{
                    error("Json parse error")
                }
        }
    }
    
    class func getNonceForAddress(_ addr: String, result: @escaping (Int64)->Void, error:@escaping (String)->Void){
        let url = "http://api.etherscan.io/api?module=proxy&action=eth_getTransactionCount&address=" + addr + "&tag=latest"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                if let value = response.result.value as? [String:AnyObject] {
                    if let val = value["result"] as? String {
                        //BigInteger nonce = new BigInteger(response.getString("result").substring(2), 16);
                        let sub_val = val.suffix(2)
                        let ret = Int64(sub_val)
                        result(ret!)
                    }else{
                        error("No result")
                    }
                } else{
                    error("Json parse error")
                }
        }
    }
    
    class func getAllProductsWithRange(uid: String, range: Int, result: @escaping ([Product]) -> Void){
        let ref = Database.database().reference()
        KRProgressHUD.show()
        ref.child(FIREBASE_PRODUCT).queryLimited(toFirst: UInt(range)).observeSingleEvent(of: .value, with: {(snapshot) in
            KRProgressHUD.dismiss()
            if snapshot.hasChildren() {
                var pr_list:[Product] = []
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let pr = Product.init(dic:sh.value as! Dictionary)
                    if pr.status == 1 {
                        pr_list.insert(pr, at: 0)
                    }
                }
                result(pr_list)
            } else {
                result([])
            }
        })
    }
    
    class func checkFavorite(uid: String, pid: String, result: @escaping (Bool)->Void, error:@escaping (String)->Void) {
        let ref = Database.database().reference()
        KRProgressHUD.show()
        ref.child(FIREBASE_FAVORITE).child(uid).queryOrderedByKey().queryEqual(toValue: pid).observeSingleEvent(of: .value, with: {(snapshot) in
            KRProgressHUD.dismiss()
            if snapshot.hasChildren() {
                result(true)
            } else {
                result(false)
            }
        })
    }
    
    class func getFavoriteWithUID(uid: String, result: @escaping ([Product])->Void) {
        let ref = Database.database().reference()
        KRProgressHUD.show()
        ref.child(FIREBASE_FAVORITE).child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            KRProgressHUD.dismiss()
            if snapshot.hasChildren() {
                var ids:[String] = []
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let one = sh.key
                    ids.insert(one, at: 0)
                }
                plist.removeAll()
                getProductList(ids: ids, ind: 0, result1: { data_result in
                    result(data_result)
                })
            } else {
                result([])
            }
        })
    }
    
    class func checkUserWithID(uid: String, result: @escaping (User)->Void, error:@escaping (String)->Void){
        let ref = Database.database().reference()
        ref.child(FIREBASE_USER).queryOrderedByKey().queryEqual(toValue: uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChildren() {
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let user = User.init(dic:sh.value as! Dictionary)
                    result(user)
                }
            } else {
                error("")
            }
        })
    }
    
    class func checkSubscription(uid: String, sid: String, result: @escaping (Bool)->Void, error:@escaping (String)->Void) {
        let ref = Database.database().reference()
        KRProgressHUD.show()
        ref.child(FIREBASE_SUBSCRIPTION).child(uid).queryOrderedByKey().queryEqual(toValue: sid).observeSingleEvent(of: .value, with: {(snapshot) in
            KRProgressHUD.dismiss()
            if snapshot.hasChildren() {
                result(true)
            } else {
                result(false)
            }
        })
    }
    
    class func getSubscribersWithUidAndRange(uid: String, range: Int, result: @escaping ([User])->Void){
        let ref = Database.database().reference()
        ref.child(FIREBASE_SUBSCRIBER).child(uid).queryLimited(toFirst: UInt(range)).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChildren() {
                var u_list:[User] = []
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let user = User.init(dic:sh.value as! Dictionary)
                    u_list.insert(user, at: 0)
                }
                result(u_list)
            } else {
                result([])
            }
        })
    }
    
    class func getSubscriptionsWithUidAndRange(uid: String, range: Int, result: @escaping ([User])->Void){
        let ref = Database.database().reference()
        ref.child(FIREBASE_SUBSCRIPTION).child(uid).queryLimited(toFirst: UInt(range)).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChildren() {
                var s_list:[String] = []
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    s_list.insert(sh.key, at: 0)
                }
                ulist.removeAll()
                getUserList(ids: s_list, ind: 0,result1: { uulist in
                    result(uulist)
                })
            } else {
                result([])
            }
        })
    }
    
    class func getUserList(ids:[String], ind:Int, result1: @escaping ([User])->Void){
        if ind == ids.count {
            result1(ulist)
            return
        }
        checkUserWithID(uid: ids[ind], result:{ prdata in
            ulist.append(prdata)
            getUserList(ids: ids, ind: ind + 1, result1: result1)
        }, error: { err in
            
        })
    }
    
    class func uploadPhoto(img: UIImage, uid: String, result: @escaping (String)->Void, error:@escaping (String)->Void){
        let img_data = img.pngData()!
        let filePath = uid +  "_\(Date().timeIntervalSince1970)" + ".png"
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let storageRef = Storage.storage().reference().child("images/" + filePath)
        KRProgressHUD.show()
        storageRef.putData(img_data, metadata: metadata) { (metaData, err) in
              if err != nil {
                KRProgressHUD.dismiss()
                error(err!.localizedDescription)
              } else {
                // your uploaded photo url.
                storageRef.downloadURL(completion: { (url, error) in
                    //code
                    KRProgressHUD.dismiss()
                    result("\(url!)")
                })
            }
         }
    }
    
    class func uploadPhotos(imgs: [UIImage], uid: String, result: @escaping ([String])->Void, error:@escaping (String)->Void){
        var path_list:[String] = []
        var index = 0
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        KRProgressHUD.show()
        for image in imgs{
            let img_data = image.pngData()!
            let filePath = uid +  "_\(Date().timeIntervalSince1970)" + ".png"
            let storageRef = Storage.storage().reference().child("images/" + filePath)
            
            storageRef.putData(img_data, metadata: metadata) { (metaData, err) in
                  if err != nil {
                    KRProgressHUD.dismiss()
                    error(err!.localizedDescription)
                  } else {
                    // your uploaded photo url.
                    storageRef.downloadURL(completion: { (url, error) in
                        //code
                        path_list.append("\(url!)")
                        index = index + 1
                        if index == imgs.count {
                            KRProgressHUD.dismiss()
                            result(path_list)
                            return
                        }
                    })
                }
             }
        }
            
    }
    
    class func getBonuschainsWithUID(uid: String, result: @escaping ([Bonus])->Void){
        let ref = Database.database().reference()
        ref.child(FIREBASE_BONUSCHAIN).queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChildren() {
                var b_list:[Bonus] = []
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let one = Bonus.init(dic: sh.value as! [String: AnyObject])
                    if one.uId == uid {
                        b_list.insert(one, at: 0)
                    }
                }
                result(b_list)
            } else {
                result([])
            }
        })
    }
    
    class func getAllOrderWithSID(sid: String, result: @escaping ([Order])->Void) {
        let ref = Database.database().reference()
        ref.child(FIREBASE_ORDER).queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChildren() {
                var b_list:[Order] = []
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let one = Order.init(dic: sh.value as! [String: AnyObject])
                    if one.sId == sid {
                        b_list.insert(one, at: 0)
                    }
                }
                result(b_list)
            } else {
                result([])
            }
        })
    }
    
    class func getAllOrderWithBID(sid: String, result: @escaping ([Order])->Void) {
        let ref = Database.database().reference()
        ref.child(FIREBASE_ORDER).queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.hasChildren() {
                var b_list:[Order] = []
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let one = Order.init(dic: sh.value as! [String: AnyObject])
                    if one.bId == sid {
                        b_list.insert(one, at: 0)
                    }
                }
                result(b_list)
            } else {
                result([])
            }
        })
    }
}

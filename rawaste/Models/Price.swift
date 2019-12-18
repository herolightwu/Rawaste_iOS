//
//  Price.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/16/19.
//

import UIKit


class Price: NSObject {
    public var ethbtc = ""
    public var ethbtc_ts = ""
    public var ethusd = ""
    public var ethusd_ts = ""
        
    public func dic_value() -> [String:Any] {
        let param:[String:Any] = [
            "ethbtc": ethbtc,
            "ethbtc_timestamp": ethbtc_ts,
            "ethusd": ethusd,
            "ethusd_timestamp": ethusd_ts
        ]
        
        return param
    }
    convenience init(dic:[String:AnyObject]) {
        self.init()
        
        if let eb = dic["ethbtc"] as? String { self.ethbtc = eb }
        if let eb_ts = dic["ethbtc_timestamp"] as? String { self.ethbtc_ts = eb_ts }
        if let eu = dic["ethusd"] as? String { self.ethusd = eu }
        if let eu_ts = dic["ethusd_timestamp"] as? String { self.ethusd_ts = eu_ts }
        
    }
}

//
//  Transaction.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/16/19.
//

import UIKit

class Transaction: NSObject {
    public var bkNum = ""
    public var ts = ""
    public var hsh = ""
    public var nonce = ""
    public var bkHash = ""
    public var tIndex = ""
    public var from = ""
    public var to = ""
    public var value = ""
    public var gas = ""
    public var gasPrice = ""
    public var isError = ""
    public var txrec_st = ""
    public var input = ""
    public var ctAddr = ""
    public var cumGas = ""
    public var gasUsed = ""
    public var confirm = ""
    
    public func dic_value() -> [String:Any] {
        let param:[String:Any] = [
            "blockNumber": bkNum,
            "timestamp": ts,
            "hash": hsh,
            "nonce": nonce,
            "blockHash": bkHash,
            "transactionIndex": tIndex,
            "from": from,
            "to": to,
            "value": value,
            "gas": gas,
            "gasPrice": gasPrice,
            "isError": isError,
            "txreceipt_status": txrec_st,
            "input": input,
            "contractAddress": ctAddr,
            "cumulativeGasUsed": cumGas,
            "gasUsed": gasUsed,
            "confirmations": confirm
        ]
        
        return param
    }
    convenience init(dic:[String:AnyObject]) {
        self.init()
        
        if let bNum = dic["blockNumber"] as? String { self.bkNum = bNum }
        if let ts = dic["timestamp"] as? String { self.ts = ts }
        if let hsh = dic["hash"] as? String { self.hsh = hsh }
        if let nc = dic["nonce"] as? String { self.nonce = nc }
        if let bh = dic["blockHash"] as? String { self.bkHash = bh }
        if let tri = dic["transactionIndex"] as? String { self.tIndex = tri }
        if let fr = dic["from"] as? String { self.from = fr}
        if let to = dic["to"] as? String { self.to = to }
        if let vl = dic["value"] as? String { self.value = vl }
        if let gs = dic["gas"] as? String { self.gas = gs }
        if let gp = dic["gasPrice"] as? String { self.gasPrice = gp }
        if let ie = dic["isError"] as? String { self.isError = ie }
        if let trs = dic["txreceipt_status"] as? String { self.txrec_st = trs }
        if let ip = dic["input"] as? String { self.input = ip }
        if let ca = dic["contractAddress"] as? String { self.ctAddr = ca }
        if let cgu = dic["cumulativeGasUsed"] as? String { self.cumGas = cgu }
        if let gu = dic["gasUsed"] as? String { self.gasUsed = gu }
        if let cf = dic["confirmation"] as? String { self.confirm = cf }
        
    }
    
}

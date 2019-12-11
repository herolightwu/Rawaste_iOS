//
//  WalletVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/11/19.
//

import UIKit
import Toaster

class WalletVC: UIViewController {

    @IBOutlet weak var lbWallet: UILabel!
    @IBOutlet weak var lbUsdWal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshView() {
        me.balance = 0
        APIManager.getTokenBalances(addr: me.address, result: { value in
            me.balance = value
            self.lbWallet.text = String.init(format: "%.4f", value)
            APIManager.getEtherPrice(result: { price in
                let eth_usd = Double(price.ethusd)!
                self.lbUsdWal.text = String.init(format:"%.2f USD", eth_usd * me.balance)
            }, error: { err in
                Toast(text: err).show()
            })
        }, error: { err in
            Toast(text: err).show()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSendClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalletSendVC") as! WalletSendVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onReceiveClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalletReceiveVC") as! WalletReceiveVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//
//  PaymentVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/12/19.
//

import UIKit
import Toaster

class PaymentVC: UIViewController {

    @IBOutlet weak var imgEtherCheck: UIImageView!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbUsdBalance: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var imgBonusCheck: UIImageView!
    @IBOutlet weak var viewEthereum: UIView!
    
    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func refreshView() {
        imgEtherCheck.image = UIImage(named: "check_empty")
        imgBonusCheck.image = UIImage(named: "check_empty")
        viewEthereum.isHidden = true
        me.balance = 0
        
        if order.type == 1 {
            viewEthereum.isHidden = false
            imgEtherCheck.image = UIImage(named: "check_checked")
            APIManager.getTokenBalances(addr: me.address, result: { value in
                me.balance = value
                self.lbBalance.text = String.init(format: "%.4f", value)
                APIManager.getEtherPrice(result: { price in
                    let eth_usd = Double(price.ethusd)
                    self.lbUsdBalance.text = String.init(format: "%.2f USD", eth_usd! * me.balance)
                }, error: { err in
                    Toast(text: err).show()
                })
            }, error: { err in
                Toast(text: err).show()
            })
        } else if order.type == 2 {
            imgBonusCheck.image = UIImage(named: "check_checked")
        }
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
    @IBAction func onPayClick(_ sender: Any) {
        if me.balance < order.total {
            Toast(text: "Insufficient Balance").show()
        }
        
        /*APIManager.checkUserWithID(uid: order.sId, result: { user in
            self.sendEthereum(user.address)
        }, error: { err in
            Toast(text: err).show()
        })*/
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BillVC") as! BillVC
        vc.order = self.order
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendEthereum(_ addr: String) {
        //Credentials keys = Credentials.create(new ECKeyPair(new BigInteger(AppData.user.privateKey), new BigInteger(AppData.user.publicKey)));
        APIManager.getNonceForAddress(me.address, result: { ret in
            /*// make raw transaction data
            RawTransaction tx = RawTransaction.createTransaction(
                    nonce,
                    gasPrice,
                    gasLimit,
                    address,
                    new BigDecimal(order.total).multiply(Constants.ONE_ETHER).toBigInteger(),
                    ""
            );
            byte[] signed = TransactionEncoder.signMessage(tx, (byte) 1, keys);
            // send transaction
            sendTransaction(signed);*/
        }, error: { err in
            Toast(text: err).show()
        })
    }
    
    
}

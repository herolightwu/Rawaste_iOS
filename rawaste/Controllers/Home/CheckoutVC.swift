//
//  CheckoutVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/11/19.
//

import UIKit
import Firebase

class CheckoutVC: UIViewController {

    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var tbCart: UITableView!
    @IBOutlet weak var lbSubTotal: UILabel!
    @IBOutlet weak var lbShipping: UILabel!
    @IBOutlet weak var lbPacking: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    
    var carts:[Product] = []
    var counts:[Int] = []
    var order:Order!
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        getCarts()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewPayment.isHidden = true
    }
    
    func getCarts(){
        APIManager.getCartWithUID(uid: me.uId, result: { (results) in
            self.carts = results
            self.counts.removeAll()
            for i in 0..<self.carts.count {
                self.counts.insert(1, at: i)
            }
            self.tbCart.reloadData()
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
    @IBAction func onContinueClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        vc.order = self.order
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshview(_ index: Int){
        let one = self.carts[index]
        self.order = Order()
        self.order.bId = me.uId
        self.order.pId = one.pId
        self.order.sId = one.uId
        self.order.type = one.pay_type
        self.order.count = self.counts[index]
        var total = 0
        var subtotal = 0
        let tax:Double = 0
        if one.pay_type == 0{
            self.lbSubTotal.text = "Free"
            self.lbTotal.text = "Free"
        } else if one.pay_type == 1 {
            subtotal = Int(one.price) * self.counts[index]
            total = subtotal
            self.lbSubTotal.text = String(subtotal) + " ETH"
            self.lbTotal.text = String(total) + " ETH"
        } else if one.pay_type == 2 {
            subtotal = one.bonus_chain * self.counts[index]
            total = subtotal
            self.lbSubTotal.text = String(subtotal) + " B"
            self.lbTotal.text = String(total) + " B"
        }
        order.tax = tax
        order.subtotal = Double(subtotal)
        order.total = Double(total)
        viewPayment.isHidden = false
    }
}

extension CheckoutVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_cart") as! CartTVCell
        let one = self.carts[indexPath.row]
        cell.delegate = self
        cell.index = indexPath.row
        cell.setData(one, count: self.counts[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.refreshview(indexPath.row)
    }
}

extension CheckoutVC: CartTVCellDelegate{
    func onTapRemove(index: Int) {
        let one = self.carts[index]
        self.ref.child(FIREBASE_CART).child(me.uId).child(one.pId).setValue(nil)
        self.carts.remove(at: index)
        self.counts.remove(at: index)
        self.tbCart.reloadData()
    }
    
    func onTapPlus(index: Int) {
        self.counts[index] = self.counts[index] + 1
        self.tbCart.reloadData()
        self.refreshview(index)
    }
    
    func onTapMinus(index: Int) {
        if self.counts[index] > 1 {
            self.counts[index] = self.counts[index] - 1
            self.tbCart.reloadData()
        }
        self.refreshview(index)
    }
}

//
//  BillVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/12/19.
//

import UIKit

class BillVC: UIViewController {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbOrderNumber: UILabel!
    @IBOutlet weak var lbSubTotal: UILabel!
    @IBOutlet weak var lbShipping: UILabel!
    @IBOutlet weak var lbPacking: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    
    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshView(){
        lbName.text = me.firstname + " " + me.lastname
        lbAddress.text = order.apartment + "\n" + order.street + "\n" + order.city
        lbOrderNumber.text = order.oId
        lbSubTotal.text = String(order.subtotal)
        lbTotal.text = String(order.total)
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
    @IBAction func onPrintClick(_ sender: Any) {
    }
    @IBAction func onProductClick(_ sender: Any) {
        APIManager.getProductWithUID(pid: order.pId, result: { (product) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
            vc.product = product
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
}

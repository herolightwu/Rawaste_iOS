//
//  OrderDetailsVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/14/19.
//

import UIKit
import MGStarRatingView
import Toaster

class OrderDetailsVC: UIViewController {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var srReview: StarRatingView!
    @IBOutlet weak var lbReview: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbId: UILabel!
    
    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func refreshView() {
        APIManager.getProductWithUID(pid: order.pId, result: { value in
            if value.images.count > 0 {
                self.imgPhoto.sd_setImage(with: URL(string: value.images[0]), completed: nil)
            }
            self.lbProductName.text = value.name
            self.lbDescription.text = value.desc
        })
        let date = Date(timeIntervalSince1970: TimeInterval(order.timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        lbDate.text = dateFormatter.string(from: date)
        lbId.text = order.oId
        lbReview.text = "95%"
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
    @IBAction func onContactSeller(_ sender: Any) {
        APIManager.checkUserWithID(uid: order.sId, result: { user in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }, error: { err in
            Toast(text: err).show()
        })
        
    }
    @IBAction func onReturnReplace(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderReplaceVC") as! OrderReplaceVC
        vc.order = order
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onCancelOrder(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderCancelVC") as! OrderCancelVC
        vc.order = order
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

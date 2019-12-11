//
//  OrderContactSellerVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/14/19.
//

import UIKit
import MGStarRatingView

class OrderContactSellerVC: UIViewController {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var srReview: StarRatingView!
    @IBOutlet weak var lbReview: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbId: UILabel!
    @IBOutlet weak var txtAsk: UITextField!
    @IBOutlet weak var txtEuro: UITextField!
    
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    @IBAction func onCameraClick(_ sender: Any) {
    }
    @IBAction func onSendClick(_ sender: Any) {
    }
    
}

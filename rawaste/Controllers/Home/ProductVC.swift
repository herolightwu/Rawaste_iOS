//
//  ProductVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/11/19.
//

import UIKit
import ReadMoreTextView
import Firebase
import Toaster

class ProductVC: UIViewController {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnFree: UIButton!
    @IBOutlet weak var btnPaid: UIButton!
    @IBOutlet weak var viewBonus: UIView!
    @IBOutlet weak var rmtvDesc: ReadMoreTextView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbFeedback: UILabel!
    @IBOutlet weak var lbEvalution: UILabel!
    @IBOutlet weak var lbItems: UILabel!
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgOnline: UIImageView!
    
    var product:Product!
    var sel_ind:Int = -1
    var seller:User!
    var ref:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        let attrib = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        let lessAtrrib = NSAttributedString(string: "Less", attributes: attrib)
        let moreAtrrib = NSAttributedString(string: "More", attributes: attrib)
        rmtvDesc.attributedReadLessText = lessAtrrib
        rmtvDesc.attributedReadMoreText = moreAtrrib
        refreshView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshView(){
        if product.images.count > 0 {
            imgPhoto.sd_setImage(with: URL(string: product.images[0]), completed: nil)
        }
        lbProductName.text = product.name
        rmtvDesc.text = product.desc
        btnFree.isHidden = true
        btnPaid.isHidden = true
        viewBonus.isHidden = true
        if product.pay_type == 0 {
            btnFree.isHidden = false
        } else if product.pay_type == 1 {
            btnPaid.isHidden = false
            btnPaid.setTitle(String(Int(product.price)), for: .normal)
        } else if product.pay_type == 2 {
            viewBonus.isHidden = false
        }
        APIManager.checkUserWithID(uid: product.uId, result: { (user) in
            self.seller = user
            if user.photo.count > 0 {
                self.imgUser.sd_setImage(with: URL(string: user.photo), completed: nil)
            }
            self.lbName.text = user.firstname + " " + user.lastname
            self.lbFeedback.text = String(user.review) + "%"
            self.lbItems.text = String(user.product_count)
            self.lbEvalution.text = String(user.evaluation)
        }, error: {err in
            
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
    @IBAction func onOrderClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onReportClick(_ sender: Any) {
    }
    
    @IBAction func onViewProfileClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.mode = .OTHER
        vc.user = seller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onContactClick(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.user = seller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onCartClick(_ sender: Any) {
        APIManager.checkCart(uid: me.uId, pid: product.pId, result: { bcheck in
            if bcheck {
                Toast(text: "This product was already added.").show()
            } else{
                self.ref.child(FIREBASE_CART).child(me.uId).child(self.product.pId).setValue(true)
                Toast(text: "Success").show()
            }
            
        })
    }
    
}

extension ProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = collectionView.bounds.size.width / 2 - 10
        return CGSize(width: 98, height: 84)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.product.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_product_detail", for: indexPath)
        let imgBg = cell.viewWithTag(11) as! UIImageView
        let imgPhoto = cell.viewWithTag(12) as! UIImageView
        if self.sel_ind == indexPath.row {
            imgBg.image = UIImage(named: "product_image_selected")?.withRenderingMode(.alwaysOriginal)
        } else{
            imgBg.image = UIImage(named: "product_image")?.withRenderingMode(.alwaysOriginal)
        }
        imgPhoto.sd_setImage(with: URL(string: product.images[indexPath.row]), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imgPhoto.sd_setImage(with: URL(string: product.images[indexPath.row]), completed: nil)
        self.sel_ind = indexPath.row
        collectionView.reloadData()
    }
}

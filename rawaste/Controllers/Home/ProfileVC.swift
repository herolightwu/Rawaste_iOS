//
//  ProfileVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/9/19.
//

import UIKit
import MGStarRatingView
import Toaster
import Firebase

class ProfileVC: UIViewController {
    enum ProfileMode {
        case ME
        case OTHER
    }

    @IBOutlet weak var viewAddSubscriber: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var srvRating: StarRatingView!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbDuns: UILabel!
    @IBOutlet weak var lbArea: UILabel!
    @IBOutlet weak var lbWasteType: UILabel!
    @IBOutlet weak var viewMe: UIView!
    @IBOutlet weak var viewOther: UIView!
    @IBOutlet weak var tbProducts: UITableView!
    
    var mode:ProfileMode = .ME
    var imagePicker: ImagePicker!
    var user:User = me
    
    var ref: DatabaseReference!
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    var products:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        imgPhoto.layer.borderColor = UIColor.white.cgColor
        imgPhoto.layer.borderWidth = 4
        imgPhoto.layer.cornerRadius = 50
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle("Wait For Loading...", for: .refreshing)
        header.setTitle("Refresh Success", for: .noMoreData)
        tbProducts.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        footer.setTitle("Loading...", for: .pulling)
        footer.setTitle("Load Success", for: .noMoreData)
        footer.setTitle("", for: .idle)
        tbProducts.mj_footer = footer
        
        if mode == .ME {
            srvRating.isUserInteractionEnabled = false
            viewOther.alpha = 0
            viewMe.alpha = 1
            viewAddSubscriber.alpha = 0
        } else{
            srvRating.isUserInteractionEnabled = false
            viewMe.alpha = 0
            viewOther.alpha = 1
            viewAddSubscriber.alpha = 1
            getProductsForUser()
        }
        
        loadData()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mode == .OTHER {
            getProductsForUser()
        }
    }
    
    @objc func headerRefresh() {
        tbProducts.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh() {
        getProductsForUser()
    }
    
    func loadData() {
        srvRating.current = CGFloat(user.review) / 20
        if user.photo.count > 0 {
            imgPhoto.sd_setImage(with: URL(string: user.photo), completed: nil)
        }
        lbRating.text = String(user.review) + "%"
        lbName.text = user.firstname + " " + user.lastname
        lbType.text = user.type
        lbDuns.text = user.duns
        lbArea.text = user.activity_area
        lbWasteType.text = user.type_waste
    }
    
    func getProductsForUser() {
        APIManager.getAllProductsWithUID(uid: user.uId, result: { (dic) in
            self.products = dic
            self.tbProducts.reloadData()
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
    @IBAction func onInformationClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InformationVC") as! InformationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onSubcriberClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriberSubscriptionVC") as! SubscriberSubscriptionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onAboutClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onAddSubscriber(_ sender: Any) {
        APIManager.checkSubscription(uid: me.uId, sid: user.uId, result: { bCheck in
            if bCheck {
                Toast(text: "This user was already added.").show()
            } else{
                self.ref.child(FIREBASE_SUBSCRIPTION).child(me.uId).child(self.user.uId).setValue(true)
                self.ref.child(FIREBASE_SUBSCRIBER).child(self.user.uId).child(me.uId).setValue(true)
                Toast(text: "Success").show()
            }
        }, error: { err in
            Toast(text: err).show()
        })
    }
    
    @IBAction func onPhotoClick(_ sender: Any) {
        if mode == .ME {
            self.imagePicker.present(from: sender as! UIView)
        }
    }
}

extension ProfileVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        APIManager.uploadPhoto(img: image!, uid: self.user.uId, result: { (path) in
            me.photo = path
            self.ref.child(FIREBASE_USER).child(me.uId).setValue(me.dic_value())
            self.loadData()
        }, error: { err in
            Toast(text: err).show()
        })
        //self.imgPhoto.image = image
    }
}

extension ProfileVC:StarRatingDelegate {
    func StarRatingValueChanged(view: StarRatingView, value: CGFloat) {
        if mode != .ME {
            
        }
    }
}

extension ProfileVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_product") as! ProductTVCell
        let one = self.products[indexPath.row]
        cell.delegate = self
        cell.index = indexPath.row
        cell.setData(one)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let one = self.products[indexPath.row]
        if one.status == 0 {
            Toast(text: "This product was deleted by seller.").show()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
            vc.product = one
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ProfileVC: ProductTVCellDelegate{
    func onTapBookmark(index: Int) {
        let sel_ind = index
        let one = self.products[sel_ind]
        APIManager.checkFavorite(uid: me.uId, pid: one.pId, result: { bExist in
            if bExist {
                Toast(text: "This product was already added").show()
            } else{
                self.ref.child(FIREBASE_FAVORITE).child(me.uId).child(one.pId).setValue(true)
                Toast(text: "Success").show()
            }
        }, error: { err in
            Toast(text: err).show()
        })
    }
}


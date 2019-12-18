//
//  AnnounceDetailVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/14/19.
//

import UIKit
import OpalImagePicker
import CountryPickerView
import SDWebImage
import Toaster
import Firebase

class AnnounceDetailVC: UIViewController {
    
    enum EditMode {
        case ADD
        case EDIT
    }
    
    enum CostMode {
        case FREE
        case PAID
        case BONUS
    }

    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var constrainContentHeight: NSLayoutConstraint!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtDescription: TextViewWithPlaceholder!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var cpvCountry: CountryPickerView!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var cpvPhone: CountryPickerView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var lbBonusCount: UILabel!
    @IBOutlet weak var imgBonusBg: UIImageView!
    @IBOutlet weak var btnFree: UIButton!
    @IBOutlet weak var btnPaid: UIButton!
    @IBOutlet weak var viewCostDetail: UIView!
    @IBOutlet weak var constCostDetail: NSLayoutConstraint!
    @IBOutlet weak var imgExchangeCheck: UIImageView!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var imgCurrency: UIImageView!
    
    var costMode:CostMode = .FREE
    var editMode:EditMode = .ADD
    var product:Product!
    var images:[UIImage] = []
    var binterest:Bool!
    var bSelImage:Bool = false
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        cpvPhone?.dataSource = self
        cpvPhone.font = UIFont.systemFont(ofSize: 17)
        
        cpvCountry?.dataSource = self
        cpvCountry.font = UIFont.systemFont(ofSize: 17)
        cpvCountry.showPhoneCodeInView = false
        cpvPhone.delegate = self
        cpvCountry.delegate = self
        
        txtPrice.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        bSelImage = false
        refreshView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshView() {
        if editMode == .ADD {
            product = Product()
            product.pay_type = -1
            viewCostDetail.isHidden = true
        } else {
            txtProductName.text = product.name
            txtDescription.text = product.desc
            txtEmail.text = product.email
            lbCountry.text = product.country_name
            cpvCountry.setCountryByCode(product.country)
            txtPhoneNumber.text = product.phone
            cpvPhone.setCountryByPhoneCode(product.country_code)
            if product.pay_type == 0{
                btnFree.setBackgroundImage(UIImage(named: "product_free_button"), for: .normal)
                btnPaid.setBackgroundImage(UIImage(named: "product_paid_default_button"), for: .normal)
                imgBonusBg.image = UIImage(named: "product_bonus_default_button")
                viewCostDetail.isHidden = true
                btnPaid.setTitle("Paid", for: .normal)
            } else if product.pay_type == 1 {
                btnFree.setBackgroundImage(UIImage(named: "product_free_default_button"), for: .normal)
                btnPaid.setBackgroundImage(UIImage(named: "product_paid_button"), for: .normal)
                imgBonusBg.image = UIImage(named: "product_bonus_default_button")
                viewCostDetail.isHidden = false
                txtPrice.accessibilityHint = "ETH"
                txtPrice.text = ""
                imgCurrency.image = UIImage(named: "ethereum")
                lbBonusCount.text = ""
                btnPaid.setTitle(String(Int(product.price)), for: .normal)
            } else if product.pay_type == 2 {
                btnFree.setBackgroundImage(UIImage(named: "product_free_default_button"), for: .normal)
                btnPaid.setBackgroundImage(UIImage(named: "product_paid_button"), for: .normal)
                imgBonusBg.image = UIImage(named: "product_bonus_default_button")
                viewCostDetail.isHidden = false
                txtPrice.accessibilityHint = "Bonuschain"
                txtPrice.text = String(product.bonus_chain)
                imgCurrency.image = UIImage(named: "bonus_coin")
                lbBonusCount.text = ""
                btnPaid.setTitle("Paid", for: .normal)
            }
            
            binterest = product.interest_exchange > 0 ? true: false
            if binterest {
                imgExchangeCheck.image = UIImage(named: "check_checked")
            } else {
                imgExchangeCheck.image = UIImage(named: "check_empty")
            }
            //images loading
            if product.images.count > 0 {
                var n = 0
                for url in product.images {
                    SDWebImageDownloader.shared.downloadImage(with: URL(string: url)) { (image, data, error, result) in
                        if let image = image {
                            self.images.append(image)
                        }
                        n += 1
                        if n == self.product.images.count {
                            self.cvPhotos.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if product.pay_type == 1 {
            btnPaid.setTitle(txtPrice.text, for: .normal)
        } else if product.pay_type == 2 {
            lbBonusCount.text = txtPrice.text
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
    @IBAction func onAddPhotoClick(_ sender: Any) {
        let config = OpalImagePickerConfiguration()
        config.doneButtonTitle = "Finish"
        config.maximumSelectionsAllowedMessage = "Sorry! There are no images here"
        let imagePicker = OpalImagePickerController()
        imagePicker.configuration = config
        imagePicker.imagePickerDelegate = self
        imagePicker.maximumSelectionsAllowed = 7
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func onPostClick(_ sender: Any) {
        if txtProductName.text?.count == 0 {
            Toast(text: "Please input product name").show()
            return
        }
        if txtDescription.text?.count == 0 {
            Toast(text: "Please input description").show()
            return
        }
        if txtEmail.text?.count == 0 {
            Toast(text: "Please input email").show()
            return
        }
        if lbCountry.text?.count == 0 {
            Toast(text: "Please select country").show()
            return
        }
        if txtPhoneNumber.text?.count == 0 {
            Toast(text: "Please input phone number").show()
            return
        }
        if product.pay_type == -1 {
            Toast(text: "Please select payment type").show()
            return
        }
        if product.pay_type > 0 && txtPrice.text?.count == 0{
            Toast(text: "Please input price").show()
            return
        }
        
        product.uId = me.uId
        product.name = txtProductName.text!
        product.desc = txtDescription.text!
        product.email = txtEmail.text!
        product.country = cpvCountry.selectedCountry.code
        product.country_name = lbCountry.text!
        product.city = txtCity.text!
        product.phone = txtPhoneNumber.text!
        product.country_code = cpvPhone.selectedCountry.phoneCode
        if product.pay_type == 1 {
            product.price = Double(txtPrice.text!)!
        } else if product.pay_type == 2{
            product.bonus_chain = Int(txtPrice.text!)!
        }
        if binterest {
            product.interest_exchange = 1
        } else {
            product.interest_exchange = 0
        }
        product.time_stamp = Int64(Date().timeIntervalSince1970)
        
        if editMode == .EDIT && !bSelImage{
            ref.child(FIREBASE_PRODUCT).child(product.pId).setValue(product.dic_value())
            self.navigationController?.popViewController(animated: true)
        } else {
            if images.count == 0{
                Toast(text: "Please choose images").show()
                return
            }
            APIManager.uploadPhotos(imgs: images, uid: me.uId, result: { (plist) in
                self.product.images = plist
                if self.editMode == .EDIT {
                    self.ref.child(FIREBASE_PRODUCT).child(self.product.pId).setValue(self.product.dic_value())
                } else {
                    self.product.pId = self.ref.child(FIREBASE_PRODUCT).childByAutoId().key!
                    self.ref.child(FIREBASE_PRODUCT).child(self.product.pId).setValue(self.product.dic_value())
                    me.product_count = me.product_count + 1
                    self.ref.child(FIREBASE_USER).child(me.uId).setValue(me.dic_value())
                }
                self.navigationController?.popViewController(animated: true)
            }, error: { err in
                Toast(text: err).show()
                return
            })
        }
    }
    @IBAction func onFreeClick(_ sender: Any) {
        btnFree.setBackgroundImage(UIImage(named: "product_free_button"), for: .normal)
        btnPaid.setBackgroundImage(UIImage(named: "product_paid_default_button"), for: .normal)
        imgBonusBg.image = UIImage(named: "product_bonus_default_button")
        viewCostDetail.isHidden = true
        btnPaid.setTitle("Paid", for: .normal)
        product.pay_type = 0
    }
    @IBAction func onPaidClick(_ sender: Any) {
        btnFree.setBackgroundImage(UIImage(named: "product_free_default_button"), for: .normal)
        btnPaid.setBackgroundImage(UIImage(named: "product_paid_button"), for: .normal)
        imgBonusBg.image = UIImage(named: "product_bonus_default_button")
        viewCostDetail.isHidden = false
        txtPrice.accessibilityHint = "ETH"
        txtPrice.text = ""
        imgCurrency.image = UIImage(named: "ethereum")
        lbBonusCount.text = ""
        product.pay_type = 1
    }
    @IBAction func onBonusClick(_ sender: Any) {
        btnFree.setBackgroundImage(UIImage(named: "product_free_default_button"), for: .normal)
        btnPaid.setBackgroundImage(UIImage(named: "product_paid_button"), for: .normal)
        imgBonusBg.image = UIImage(named: "product_bonus_default_button")
        viewCostDetail.isHidden = false
        txtPrice.accessibilityHint = "Bonuschain"
        txtPrice.text = String(product.bonus_chain)
        imgCurrency.image = UIImage(named: "bonus_coin")
        btnPaid.setTitle("Paid", for: .normal)
        product.pay_type = 2
    }
    @IBAction func onExchangeClick(_ sender: Any) {
        if binterest {
            imgExchangeCheck.image = UIImage(named: "check_empty")
            binterest = false
        } else{
            imgExchangeCheck.image = UIImage(named: "check_checked")
            binterest = true
        }
    }
    
}

extension AnnounceDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = collectionView.bounds.size.width / 2 - 10
        return CGSize(width: 98, height: 84)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_product_detail", for: indexPath)
        let imgPhoto = cell.viewWithTag(12) as! UIImageView
        imgPhoto.image = self.images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension AnnounceDetailVC: OpalImagePickerControllerDelegate{
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]){
        picker.dismiss(animated: true, completion: nil)
        self.images = images
        self.bSelImage = true
        self.cvPhotos.reloadData()
    }
    func imagePickerDidCancel(_ picker: OpalImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AnnounceDetailVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        self.lbCountry.text = country.name
    }
}

extension AnnounceDetailVC: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        return []
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
        
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        if countryPickerView == self.cpvCountry {
            return false
        }
        return true
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        if countryPickerView == self.cpvPhone {
            return false
        }
       return true
    }
}

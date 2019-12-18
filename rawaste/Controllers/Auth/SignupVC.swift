//
//  SignupVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/3/19.
//

import UIKit
import CountryPickerView
import iOSDropDown
import Firebase
import Toaster

class SignupVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtDuns: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtWasteType: UITextField!
    @IBOutlet weak var chAccept: ImageCheckBox!
    @IBOutlet weak var cpvMain: CountryPickerView!
    @IBOutlet weak var ddType: DropDown!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        cpvMain?.dataSource = self as CountryPickerViewDataSource
        cpvMain.font = UIFont.systemFont(ofSize: 17)
        
        ddType.borderWidth = 1
        ddType.borderStyle = .line
        
        ddType.optionArray = [
            "Individual",
            "Company"
        ]
        ddType.text = "Individual"
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
    @IBAction func onTermsClick(_ sender: Any) {
    }
    
    @IBAction func onRegister(_ sender: Any) {
        if checkValid() {
            let user = User()
            user.email = txtEmail.text!
            user.firstname = txtFname.text!
            user.lastname = txtLname.text!
            user.type = ddType.text!
            user.country_code = cpvMain.selectedCountry.phoneCode
            user.phone = txtPhone.text!
            user.duns = txtDuns.text!
            user.activity_area = txtArea.text!
            user.type_waste = txtWasteType.text!
            //Generate encrypt key
            //end key
            // [START create_user]
            Auth.auth().createUser(withEmail: user.email, password: txtPass.text!) { authResult, error in
              // [START_EXCLUDE]
              guard let reg_user = authResult?.user, error == nil else {
                //showAlert(parent: self, title: "Warning!", msg: error!.localizedDescription)
                Toast(text: error!.localizedDescription).show()
                return
              }
              print("\(reg_user.email!) created")
                user.uId = reg_user.uid
                me = user
                self.ref.child(FIREBASE_USER).child(me.uId).setValue(me.dic_value())
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc2 = storyboard.instantiateInitialViewController()
                UIApplication.shared.delegate!.window!!.rootViewController = vc2
              // [END_EXCLUDE]
            }
            // [END create_user]
        }
    }
    func showDismiss(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func checkValid() -> Bool{
        if txtEmail.text?.count == 0 {
            //showAlert(parent: self, title: "Warning!", msg: "Please input email.")
            Toast(text: "Please input email.").show()
            return false
        }
        if !isValidEmail(txtEmail.text!) {
            Toast(text: "Invalid email").show()
            return false
        }
        if txtFname.text?.count == 0 {
            Toast(text: "Please input Firstname").show()
            return false
        }
        if txtLname.text?.count == 0 {
            Toast(text: "Please input Lastname").show()
            return false
        }
        if txtPass.text?.count == 0 {
            Toast(text: "Please input password.").show()
            return false
        }
        if txtPass.text != txtConfirm.text {
            Toast(text: "Incorrect confirm password.").show()
            return false
        }
        if txtPhone.text?.count == 0 {
            Toast(text: "Please input phone number.").show()
            return false
        }
        if !chAccept.isChecked {
            Toast(text: "Please accept terms and conditions.").show()
            return false
        }
        return true
    }
}

extension SignupVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        showDismiss(title: title, message: message)
    }
}

extension SignupVC: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        var countries = [Country]()
        ["NG", "US", "GB"].forEach { code in
            if let country = countryPickerView.getCountryByCode(code) {
                countries.append(country)
            }
        }
        return countries
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return "Preferred Country"
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
        
    /*func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        if countryPickerView.tag == cpvMain.tag {
            switch searchBarPosition.selectedSegmentIndex {
            case 0: return .tableViewHeader
            case 1: return .navigationBar
            default: return .hidden
            }
        }
        return .tableViewHeader
    }*/
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
       return true
    }
}

//
//  InformationVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/10/19.
//

import UIKit
import CountryPickerView
import iOSDropDown
import Toaster
import Firebase

class InformationVC: UIViewController {

    @IBOutlet weak var txtFirst: UITextField!
    @IBOutlet weak var txtLast: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var cpvMain: CountryPickerView!
    @IBOutlet weak var txtDuns: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtWasteType: UITextField!
    @IBOutlet weak var ddType: DropDown!
    
    var ref:DatabaseReference!
    
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
        ddType.selectedIndex = 0
        refreshView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshView(){
        txtFirst.text = me.firstname
        txtLast.text = me.lastname
        if me.type == "Individual" {
            ddType.selectedIndex = 0
        } else {
            ddType.selectedIndex = 1
        }
        cpvMain.setCountryByPhoneCode(me.country_code)
        txtPhone.text = me.phone
        txtDuns.text = me.duns
        txtArea.text = me.activity_area
        txtWasteType.text = me.type_waste
        
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
    
    @IBAction func onSaveClick(_ sender: Any) {
        if txtFirst.text?.count == 0 {
            Toast(text: "Please input Firstname").show()
            return
        }
        if txtLast.text?.count == 0 {
            Toast(text: "Please input Lastname").show()
            return
        }
        if txtPhone.text?.count == 0 {
            Toast(text: "Please input phone number.").show()
            return
        }
        
        me.firstname = txtFirst.text!
        me.lastname = txtLast.text!
        me.country_code = cpvMain.selectedCountry.phoneCode
        me.phone = txtPhone.text!
        me.type = ddType.text!
        me.duns = txtDuns.text!
        me.type_waste = txtWasteType.text!
        me.activity_area = txtArea.text!
        
        ref.child(FIREBASE_USER).child(me.uId).setValue(me.dic_value())
        self.navigationController?.popViewController(animated: true)
    }
}


extension InformationVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        
    }
}

extension InformationVC: CountryPickerViewDataSource {
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

//
//  AddressVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/12/19.
//

import UIKit
import CountryPickerView
import Toaster

class AddressVC: UIViewController {

    @IBOutlet weak var txtApartment: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var cpvPhone: CountryPickerView!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var cpvCountry: CountryPickerView!
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var cbSave: ImageCheckBox!
    
    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cpvPhone?.dataSource = self as CountryPickerViewDataSource
        cpvPhone.font = UIFont.systemFont(ofSize: 17)
        
        cpvCountry?.dataSource = self as CountryPickerViewDataSource
        cpvCountry?.delegate = self
        cpvCountry.font = UIFont.systemFont(ofSize: 17)
        cpvCountry.showPhoneCodeInView = false
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lbCountry.text = cpvCountry.selectedCountry.name
        refreshView()
    }
    
    func refreshView() {
        if getString(ADDRESS_ISSAVED) == "1" {
            txtApartment.text = getString(ADDRESS_APARTMENT)
            txtStreet.text = getString(ADDRESS_STREET)
            txtCity.text = getString(ADDRESS_CITY)
            txtPhone.text = getString(ADDRESS_PHONE)
            lbCountry.text = getString(ADDRESS_COUNTRY)
            txtPincode.text = getString(ADDRESS_PINCODE)
            cpvPhone.setCountryByPhoneCode(getString(ADDRESS_PHONE_CODE))
            cpvCountry.setCountryByCode(getString(ADDRESS_COUNTRY_CODE))
            cbSave.isChecked = true
        } else {
            cbSave.isChecked = false
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
    @IBAction func onCheckClick(_ sender: Any) {
        if cbSave.isChecked {
            cbSave.isChecked = false
        } else{
            cbSave.isChecked = true
        }
    }
    @IBAction func onContinueClick(_ sender: Any) {
        if txtApartment.text!.count == 0 {
            Toast(text: "Please input Apartment/Building Name.").show()
            return
        }
        if txtStreet.text!.count == 0 {
            Toast(text: "Please input Street Address.").show()
            return
        }
        if txtCity.text!.count == 0 {
            Toast(text: "Please input City.").show()
            return
        }
        if lbCountry.text!.count == 0 {
            Toast(text: "Please input Country.").show()
            return
        }
        if txtPhone.text!.count == 0 {
            Toast(text: "Please input Phone Number.").show()
            return
        }
        if txtPincode.text!.count == 0 {
            Toast(text: "Please input Pincode.").show()
            return
        }
        if cbSave.isChecked {
            putString(ADDRESS_APARTMENT, val:txtApartment.text!)
            putString(ADDRESS_STREET, val:txtStreet.text!)
            putString(ADDRESS_CITY, val:txtCity.text!)
            putString(ADDRESS_PHONE, val:txtPhone.text!)
            putString(ADDRESS_COUNTRY, val:lbCountry.text!)
            putString(ADDRESS_PINCODE, val:txtPincode.text!)
            putString(ADDRESS_PHONE_CODE, val:cpvPhone.selectedCountry.phoneCode)
            putString(ADDRESS_COUNTRY_CODE, val: cpvCountry.selectedCountry.code)
            putString(ADDRESS_ISSAVED, val:"1")
        } else {
            putString(ADDRESS_ISSAVED, val:"0")
        }
        order.apartment = txtApartment.text!
        order.street = txtStreet.text!
        order.city = txtCity.text!
        order.country = lbCountry.text!
        order.phone = txtPhone.text!
        order.pincode = txtPincode.text!
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        vc.order = order
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AddressVC: CountryPickerViewDataSource, CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        if countryPickerView == self.cpvCountry {
            self.lbCountry.text = country.name
        }
    }
    
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
        
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
       return true
    }
}

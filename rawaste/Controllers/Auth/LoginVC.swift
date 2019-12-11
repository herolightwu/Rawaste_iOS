//
//  LoginVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/3/19.
//  Copyright © 2019 MeiXiang Wu. All rights reserved.
//

import UIKit
import Firebase
import Toaster
import KRProgressHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var checkBox: ImageCheckBox!
    var bShow:Bool = false
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        checkLogin()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func checkLogin() {
        if getString(IS_LOGINED) == "1" {
            let email = getString(LOGIN_EMAIL)
            let pass = getString(LOGIN_PASS)
            txtEmail.text = email
            txtPassword.text = pass
            signinUser(email, pwd: pass)
        } else{
            let email = getString(LOGIN_EMAIL)
            let pass = getString(LOGIN_PASS)
            txtEmail.text = email
            txtPassword.text = pass
        }
    }
    
    func signinUser(_ email:String , pwd: String){
        KRProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: pwd) { [weak self] authResult, error in
            KRProgressHUD.dismiss()
          guard let strongSelf = self else { return }
          // [START_EXCLUDE]
          if let error = error {
            Toast(text: error.localizedDescription).show()
            return
          }
            let fuser = authResult?.user
            let user = User()
            user.email = fuser!.email!
            user.uId = fuser!.uid
          strongSelf.checkUser(user)
          // [END_EXCLUDE]
        }
        // [END headless_email_auth]*/
    }
    
    func checkUser(_ user:User) {
        KRProgressHUD.show()
        self.ref.child(FIREBASE_USER).queryOrderedByKey().queryEqual(toValue: user.uId).observeSingleEvent(of: .value, with: {(snapshot) in
            KRProgressHUD.dismiss()
            if snapshot.hasChildren() {
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let data = sh.value as! [String: AnyObject]
                    me = User.init(dic: data)
                    if self.checkBox.isChecked {
                        putString(IS_LOGINED, val: "1")
                        putString(LOGIN_EMAIL, val: me.email)
                        putString(LOGIN_PASS, val: self.txtPassword.text!)
                    }
                    if me.address.count == 0 {
                        me.address = SERVER_ADDRESS
                        me.publicKey = SERVER_PUBLIC_KEY
                        me.privateKey = SERVER_PRIVATE_KEY
                    }
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc2 = storyboard.instantiateInitialViewController()
                    UIApplication.shared.delegate!.window!!.rootViewController = vc2
                    return
                }
            }
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
    @IBAction func onSignInClick(_ sender: Any) {
        if checkValid(){
            signinUser(txtEmail.text!, pwd: txtPassword.text!)
        }
    }
    @IBAction func onSignUpClick(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onForgotClick(_ sender: Any) {
        if txtEmail.text?.count == 0 {
            Toast(text: "Please input email").show()
            return
        }
        if !isValidEmail(txtEmail.text!) {
            Toast(text: "Invalid email").show()
            return
        }
        // [START password_reset]
        Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { error in
          // [START_EXCLUDE]
          if let error = error {
            Toast(text: error.localizedDescription).show()
            return
          }
            Toast(text: "Email sent").show()
          // [END_EXCLUDE]
        }
        // [END password_reset]*/
    }
        
    @IBAction func onRememberClick(_ sender: Any) {
        if checkBox.isChecked{
            checkBox.isChecked = false
        } else{
            checkBox.isChecked = true
        }
    }
    @IBAction func onShowPass(_ sender: Any) {
        bShow = !bShow
        if bShow {
            txtPassword.isSecureTextEntry = false
        } else {
            txtPassword.isSecureTextEntry = true
        }
    }
    
    func checkValid() -> Bool{
        if txtEmail.text?.count == 0 {
            Toast(text: "Please input email.").show()
            return false
        }
        if !isValidEmail(txtEmail.text!) {
            Toast(text: "Invalid email").show()
            return false
        }
        if txtPassword.text?.count == 0 {
            Toast(text: "Please input password.").show()
            return false
        }
        return true
    }
    
}

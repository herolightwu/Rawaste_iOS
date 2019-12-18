//
//  MenuVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/8/19.
//

import UIKit
import SideMenuSwift

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class MenuVC: UIViewController {

    var isDarkModeEnabled = false
        
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbWallet: UILabel!
    
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
        private var themeColor = UIColor.white

        override func viewDidLoad() {
            super.viewDidLoad()
            
            imgPhoto.layer.cornerRadius = 45
            imgPhoto.layer.borderColor = UIColor.white.cgColor
            imgPhoto.layer.borderWidth = 4

            isDarkModeEnabled = SideMenuController.preferences.basic.position == .under
            let wallet_tap = UITapGestureRecognizer(target: self, action: #selector(MenuVC.onWalletClick))
            lbWallet.addGestureRecognizer(wallet_tap)
            
            configureView()

            sideMenuController?.delegate = self
            refreshView()
        }

        private func configureView() {
            let sidemenuBasicConfiguration = SideMenuController.preferences.basic
            let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
            if showPlaceTableOnLeft {
                selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
            }
        }

        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)

            let sidemenuBasicConfiguration = SideMenuController.preferences.basic
            let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
            selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
            view.layoutIfNeeded()
        }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }
    
    func refreshView() {
        if me.photo.count > 0 {
            imgPhoto.sd_setImage(with: URL(string: me.photo), completed: nil)
        }
        lbUsername.text = me.firstname + " " + me.lastname
        let sWal = String.init(format: "%.4f ETH", me.balance)
        lbWallet.text = sWal
    }
    
    @objc func onWalletClick(sender: UITapGestureRecognizer){
        NotificationCenter.default.post(name: Notification.Name("showWallet"), object: nil)
        sideMenuController?.hideMenu()
    }
    
    @IBAction func onMenuMessageClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showMessage"), object: nil)
        sideMenuController?.hideMenu()
    }
    @IBAction func onMenuAnnounceClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showAnnounce"), object: nil)
        sideMenuController?.hideMenu()
    }
    @IBAction func onMenuOrderClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showOrders"), object: nil)
        sideMenuController?.hideMenu()
    }
    @IBAction func onMenuPurchaseClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showPurchases"), object: nil)
        sideMenuController?.hideMenu()
    }
    @IBAction func onMenuBonuschainClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showBonus"), object: nil)
        sideMenuController?.hideMenu()
    }
    @IBAction func onMenuServiceClick(_ sender: Any) {
        sideMenuController?.hideMenu()
    }
    @IBAction func onSignOut(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showSignout"), object: nil)
        sideMenuController?.hideMenu()
    }
    @IBAction func onPhotoClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showProfile"), object: nil)
        sideMenuController?.hideMenu()
    }
    
}

    extension MenuVC: SideMenuControllerDelegate {
        func sideMenuController(_ sideMenuController: SideMenuController,
                                animationControllerFrom fromVC: UIViewController,
                                to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
        }

        func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
            print("[Example] View controller will show [\(viewController)]")
        }

        func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
            print("[Example] View controller did show [\(viewController)]")
        }

        func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
            print("[Example] Menu will hide")
        }

        func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
            print("[Example] Menu did hide.")
        }

        func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
            print("[Example] Menu will reveal.")
        }

        func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
            print("[Example] Menu did reveal.")
        }
    }



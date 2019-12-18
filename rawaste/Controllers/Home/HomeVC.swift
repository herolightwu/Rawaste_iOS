//
//  HomeVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/8/19.
//

import UIKit
import SideMenuSwift
import CountryPickerView
import Firebase
import Toaster

class HomeVC: UIViewController {
    
    enum Mode {
        case NORMAL
        case SEARCH
        case ADVANCED
        case FILTER
    }

    @IBOutlet weak var lbChartNum: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewDisFree: UIView!
    @IBOutlet weak var viewOption: UIView!
    @IBOutlet weak var viewAdvanced: UIView!
    @IBOutlet weak var constOptionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constTableTop: NSLayoutConstraint!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var tvProduct: UITableView!
    @IBOutlet weak var cpvCountry: CountryPickerView!
    
    var ref: DatabaseReference!
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    var products:[Product] = []
    var range:Int = 20
    
    var mode:Mode = .NORMAL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile), name: Notification.Name("showProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showWallet), name: Notification.Name("showWallet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMessage), name: Notification.Name("showMessage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAnnounce), name: Notification.Name("showAnnounce"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showOrders), name: Notification.Name("showOrders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPurchases), name: Notification.Name("showPurchases"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBonus), name: Notification.Name("showBonus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSignout), name: Notification.Name("showSignout"), object: nil)
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        //cpvCountry?.dataSource = self as CountryPickerViewDataSource
        cpvCountry.font = UIFont.systemFont(ofSize: 16)
        cpvCountry.showPhoneCodeInView = false
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle("Wait For Loading...", for: .refreshing)
        header.setTitle("Refresh Success", for: .noMoreData)
        tvProduct.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        footer.setTitle("Loading...", for: .pulling)
        footer.setTitle("Load Success", for: .noMoreData)
        footer.setTitle("", for: .idle)
        tvProduct.mj_footer = footer
        
        configureUI()
        getProducts(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCartAndBalance()
        refreshLayout()
    }
    
    @objc func headerRefresh() {
        tvProduct.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh() {
        range += 20
        getProducts(false)
    }
    
    private func configureUI() {
        SideMenuController.preferences.basic.statusBarBehavior = .none
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.supportedOrientations = .portrait
    }
    
    private func refreshLayout() {
        switch mode {
        case .NORMAL:
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:
            {
                self.viewDisFree.alpha = 1.0
                self.viewOption.alpha = 0
            }, completion: nil)
            constTableTop.constant = viewDisFree.frame.size.height + 16
        case .SEARCH:
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:
            {
                self.viewDisFree.alpha = 0
                self.viewOption.alpha = 1
            }, completion: nil)
            constOptionHeight.constant = 50
            constTableTop.constant = 66
        case .ADVANCED:
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:
            {
                self.viewDisFree.alpha = 0
                self.viewOption.alpha = 1
                self.viewAdvanced.alpha = 1
                self.viewFilter.alpha = 0
            }, completion: nil)
            constOptionHeight.constant = 350
            
            constTableTop.constant = 366
        case .FILTER:
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations:
            {
                self.viewDisFree.alpha = 0
                self.viewOption.alpha = 1
                self.viewAdvanced.alpha = 0
                self.viewFilter.alpha = 1
            }, completion: nil)
            constOptionHeight.constant = 142
            
            constTableTop.constant = 158
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func checkCartAndBalance(){
        lbChartNum.isHidden = true
        APIManager.getCartWithUID(uid: me.uId, result: { result in
            if result.count > 0 {
                self.lbChartNum.text = String(result.count)
                self.lbChartNum.isHidden = false
            }
        })
        APIManager.getTokenBalances(addr: me.address, result: { value in
            me.balance = value
        }, error: { err in
            Toast(text: err).show()
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.txtSearch.text!.count > 0 {
            self.mode = .SEARCH
        } else{
            self.mode = .NORMAL
        }
        self.refreshLayout()
    }
    
    @objc func showBonus (notification: NSNotification) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BonuschainVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showPurchases (notification: NSNotification) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SalesPurchaseVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showOrders (notification: NSNotification) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showAnnounce (notification: NSNotification) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AnnouncementVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showMessage (notification: NSNotification) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showSignout (notification: NSNotification) {
        putString(IS_LOGINED, val: "0")
        let storyboard:UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showProfile (notification: NSNotification) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showWallet (notification: NSNotification) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getProducts(_ bPage: Bool){
        APIManager.getAllProductsWithRange(uid: me.uId, range: range, result: { (pr_list) in
            self.products = pr_list
            self.tvProduct.reloadData()
            if self.tvProduct.mj_footer!.isRefreshing {
                self.tvProduct.mj_footer?.endRefreshing()
            }
            if !bPage {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.products.count - 1, section: 0)
                    self.tvProduct.scrollToRow(at: indexPath, at: .top, animated: false)
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
    @IBAction func onCartClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onMenuClick(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    @IBAction func onAdvancedClick(_ sender: Any) {
        if mode != .ADVANCED {
            mode = .ADVANCED
        } else {
            mode = .SEARCH
        }
        
        refreshLayout()
    }
    @IBAction func onFilterClick(_ sender: Any) {
        if mode != .FILTER {
            mode = .FILTER
        } else {
            mode = .SEARCH
        }
        refreshLayout()
    }
    
}

extension HomeVC:UITableViewDataSource, UITableViewDelegate {
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
        if one.uId == me.uId {
            Toast(text: "This product is posted by you.").show()
        } else if one.status == 0 {
            Toast(text: "This product was deleted by seller.").show()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
            vc.product = one
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC: ProductTVCellDelegate{
    func onTapBookmark(index: Int) {
        let sel_ind = index
        let one = self.products[sel_ind]
        if one.uId == me.uId {
            Toast(text: "This product is posted by you.").show()
        } else{
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
}

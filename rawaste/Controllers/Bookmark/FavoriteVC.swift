//
//  FavoriteVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/9/19.
//

import UIKit
import Firebase
import Toaster

class FavoriteVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    var products:[Product] = []
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle("Wait For Loading...", for: .refreshing)
        header.setTitle("Refresh Success", for: .noMoreData)
        mTableView.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        footer.setTitle("Loading...", for: .pulling)
        footer.setTitle("Load Success", for: .noMoreData)
        footer.setTitle("", for: .idle)
        mTableView.mj_footer = footer
        getFavorites()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func headerRefresh() {
        mTableView.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh() {
        getFavorites()
    }
    
    func getFavorites() {
        APIManager.getFavoriteWithUID(uid: me.uId, result: { (plist) in
            self.products = plist
            self.mTableView.reloadData()
            if self.mTableView.mj_footer!.isRefreshing {
                self.mTableView.mj_footer?.endRefreshing()
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

}

extension FavoriteVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_favorite") as! FavoriteTVCell
        let one = self.products[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        cell.setData(one)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let one = self.products[indexPath.row]
        if one.status == 0 {
            Toast(text: "This product was already deleted.").show()
            return
        }
        let storyboard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        vc.product = one
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavoriteVC: FavoriteTVCellDelegate {
    func onTapDelete(index: Int) {
        let one = self.products[index]
        self.ref.child(FIREBASE_FAVORITE).child(me.uId).child(one.pId).setValue(nil)
        self.products.remove(at: index)
        self.mTableView.reloadData()
    }
}

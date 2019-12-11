//
//  AnnouncementVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/13/19.
//

import UIKit
import Firebase

class AnnouncementVC: UIViewController {

    @IBOutlet weak var tbAnnounce: UITableView!
    @IBOutlet weak var lbItems: UILabel!
    
    var products:[Product] = []
    
    var ref: DatabaseReference!
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle("Wait For Loading...", for: .refreshing)
        header.setTitle("Refresh Success", for: .noMoreData)
        tbAnnounce.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        footer.setTitle("Loading...", for: .pulling)
        footer.setTitle("Load Success", for: .noMoreData)
        footer.setTitle("", for: .idle)
        tbAnnounce.mj_footer = footer
        refreshView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func headerRefresh() {
        tbAnnounce.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh() {
        refreshView()
    }
    
    func refreshView() {
        lbItems.text = "0 Items"
        APIManager.getAllProductsWithUID(uid: me.uId, result: { (plist) in
            self.products = plist
            self.lbItems.text = String(plist.count) + " Items"
            self.tbAnnounce.reloadData()
            if self.tbAnnounce.mj_footer!.isRefreshing {
                self.tbAnnounce.mj_footer?.endRefreshing()
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
    @IBAction func onBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onAddClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnnounceDetailVC") as! AnnounceDetailVC
        vc.editMode = .ADD
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension AnnouncementVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let one = self.products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_announcement") as! AnnounceTVCell
        cell.index = indexPath.row
        cell.delegate = self
        cell.setData(one)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AnnouncementVC: AnnounceTVCellDelegate {
    func onTapModify(index: Int) {
        let one = self.products[index]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AnnounceDetailVC") as! AnnounceDetailVC
        vc.editMode = .EDIT
        vc.product = one
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onTapRemove(index: Int) {
        let one = self.products[index]
        self.ref.child(FIREBASE_PRODUCT).child(one.pId).child("status").setValue(0);
        self.products.remove(at: index)
        self.lbItems.text = String(self.products.count) + " Items"
        me.product_count = me.product_count - 1
        self.ref.child(FIREBASE_USER).child(me.uId).setValue(me.dic_value())
        self.tbAnnounce.reloadData()
    }
}

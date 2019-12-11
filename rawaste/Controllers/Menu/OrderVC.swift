//
//  OrderVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/14/19.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet weak var tbOrder: UITableView!
    
    var orders:[Order] = []
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header.setTitle("Wait For Loading...", for: .refreshing)
        header.setTitle("Refresh Success", for: .noMoreData)
        tbOrder.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        footer.setTitle("Loading...", for: .pulling)
        footer.setTitle("Load Success", for: .noMoreData)
        footer.setTitle("", for: .idle)
        tbOrder.mj_footer = footer
        
        getOrders()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func headerRefresh() {
        tbOrder.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh() {
        getOrders()
    }
    
    func getOrders(){
        APIManager.getAllOrderWithBID(sid: me.uId, result: { (slist) in
            self.orders = slist
            self.tbOrder.reloadData()
            if self.tbOrder.mj_footer!.isRefreshing {
                self.tbOrder.mj_footer?.endRefreshing()
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
    
}

extension OrderVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell_order")
        let one = self.orders[indexPath.row]
        let imgPhoto = cell.viewWithTag(1) as! UIImageView
        let lbName = cell.viewWithTag(2) as! UILabel
        let lbDesc = cell.viewWithTag(3) as! UILabel
        let lbDate = cell.viewWithTag(4) as! UILabel
        let lbID = cell.viewWithTag(5) as! UILabel
        APIManager.getProductWithUID(pid: one.pId, result: { value in
            if value.images.count > 0 {
                imgPhoto.sd_setImage(with: URL(string: value.images[0]), completed: nil)
            }
            lbName.text = value.name
            lbDesc.text = value.desc
        })
        let date = Date(timeIntervalSince1970: TimeInterval(one.timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        lbDate.text = dateFormatter.string(from: date)
        lbID.text = one.oId
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let one = self.orders[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.order = one
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

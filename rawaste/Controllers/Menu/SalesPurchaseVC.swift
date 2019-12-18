//
//  SalesPurchaseVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/15/19.
//

import UIKit
import MGStarRatingView

class SalesPurchaseVC: UIViewController {
    enum SalesMode {
        case SALES
        case PURCHASES
    }

    @IBOutlet weak var lbSales: UILabel!
    @IBOutlet weak var lbPurchase: UILabel!
    @IBOutlet weak var btnSales: UIButton!
    @IBOutlet weak var btnPurchases: UIButton!
    @IBOutlet weak var tbSales: UITableView!
    @IBOutlet weak var tbPurchases: UITableView!
    
    var mode:SalesMode = .SALES
    let header_sales = MJRefreshNormalHeader()
    let header_purchase = MJRefreshNormalHeader()
    let footer_sales = MJRefreshAutoNormalFooter()
    let footer_purchase = MJRefreshAutoNormalFooter()
    
    var oSales:[Order] = []
    var oPurchases:[Order] = []
    var range1:Int = 20
    var range0:Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        header_sales.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh_sales))
        header_sales.setTitle("Wait For Loading...", for: .refreshing)
        header_sales.setTitle("Refresh Success", for: .noMoreData)
        tbSales.mj_header = header_sales
        footer_sales.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh_sales))
        footer_sales.setTitle("Loading...", for: .pulling)
        footer_sales.setTitle("Load Success", for: .noMoreData)
        footer_sales.setTitle("", for: .idle)
        tbSales.mj_footer = footer_sales
        //purchases
        header_purchase.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh_purchase))
        header_purchase.setTitle("Wait For Loading...", for: .refreshing)
        header_purchase.setTitle("Refresh Success", for: .noMoreData)
        tbPurchases.mj_header = header_purchase
        footer_purchase.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh_purchase))
        footer_purchase.setTitle("Loading...", for: .pulling)
        footer_purchase.setTitle("Load Success", for: .noMoreData)
        footer_purchase.setTitle("", for: .idle)
        tbPurchases.mj_footer = footer_purchase
        
        refreshLayout()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func refreshLayout() {
        if mode == .SALES {
            tbSales.isHidden = false
            tbPurchases.isHidden = true
            lbSales.isHidden = true
            lbPurchase.isHidden = false
            btnSales.setTitle("Sales", for: .normal)
            btnPurchases.setTitle("", for: .normal)
            getSales(true)
        } else {
            tbSales.isHidden = true
            tbPurchases.isHidden = false
            lbSales.isHidden = false
            lbPurchase.isHidden = true
            btnSales.setTitle("", for: .normal)
            btnPurchases.setTitle("Purchases", for: .normal)
            getPurchases(true)
        }
    }
    
    @objc func headerRefresh_sales() {
        tbSales.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh_sales() {
        range0 += 20
        getSales(false)
    }
    
    @objc func headerRefresh_purchase() {
        tbPurchases.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh_purchase() {
        range1 += 20
        getPurchases(false)
    }
    
    func getSales(_ bPage: Bool){
        APIManager.getAllOrderWithSID(sid: me.uId, result: { (slist) in
            self.oSales = slist
            self.tbSales.reloadData()
            if self.tbSales.mj_footer!.isRefreshing {
                self.tbSales.mj_footer?.endRefreshing()
            }
            if !bPage {
                DispatchQueue.main.async {
                    if self.oSales.count > 1 {
                        let indexPath = IndexPath(row: self.oSales.count - 1, section: 0)
                        self.tbSales.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
            }
        })
    }
    
    func getPurchases(_ bPage: Bool) {
        APIManager.getAllOrderWithBID(sid: me.uId, result: { (slist) in
            self.oPurchases = slist
            self.tbPurchases.reloadData()
            if self.tbPurchases.mj_footer!.isRefreshing {
                self.tbPurchases.mj_footer?.endRefreshing()
            }
            if !bPage {
                DispatchQueue.main.async {
                    if self.oPurchases.count > 1 {
                        let indexPath = IndexPath(row: self.oPurchases.count - 1, section: 0)
                        self.tbPurchases.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
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
    @IBAction func onBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onSalesClick(_ sender: Any) {
        mode = .SALES
        range0 = 0
        refreshLayout()
    }
    @IBAction func onPurchasesClick(_ sender: Any) {
        mode = .PURCHASES
        range1 = 0
        refreshLayout()
    }
    
}

extension SalesPurchaseVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tbSales {
            return self.oSales.count
        } else {
            return self.oPurchases.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if tableView == tbSales {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell_sales")
            let one = self.oSales[indexPath.row]
            let imgPhoto = cell.viewWithTag(1) as! UIImageView
            let lbName = cell.viewWithTag(2) as! UILabel
            let lbDesc = cell.viewWithTag(3) as! UILabel
            let lbSold = cell.viewWithTag(4) as! UILabel
            let lbOID = cell.viewWithTag(5) as! UILabel
            let lbPrice = cell.viewWithTag(6) as! UILabel
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
            lbSold.text = dateFormatter.string(from: date)
            lbOID.text = one.oId
            lbPrice.text = String.init(format: "%.2f", one.total)
        } else if tableView == tbPurchases {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell_purchases")
            let one = self.oPurchases[indexPath.row]
            let imgPhoto = cell.viewWithTag(1) as! UIImageView
            let lbName = cell.viewWithTag(2) as! UILabel
            let lbDate = cell.viewWithTag(4) as! UILabel
            let lbOID = cell.viewWithTag(5) as! UILabel
            //let srvRate = cell.viewWithTag(6) as! StarRatingView
            APIManager.getProductWithUID(pid: one.pId, result: { value in
                if value.images.count > 0 {
                    imgPhoto.sd_setImage(with: URL(string: value.images[0]), completed: nil)
                }
                lbName.text = value.name
            })
            let date = Date(timeIntervalSince1970: TimeInterval(one.timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yy"
            lbDate.text = dateFormatter.string(from: date)
            lbOID.text = one.oId
        } else{
            cell = nil
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var order: Order!
        if tableView == tbSales {
            order = self.oSales[indexPath.row]
        } else{
            order = self.oPurchases[indexPath.row]
        }
        let storyboard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BillVC") as! BillVC
        vc.order = order
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

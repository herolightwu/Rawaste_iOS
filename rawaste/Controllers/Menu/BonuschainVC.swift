//
//  BonuschainVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/15/19.
//

import UIKit

class BonuschainVC: UIViewController {
    
    @IBOutlet weak var lbBonus: UILabel!
    @IBOutlet weak var tbTransaction: UITableView!
    
    var bonus:[Bonus] = []
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        footer.setTitle("Loading...", for: .pulling)
        footer.setTitle("Load Success", for: .noMoreData)
        footer.setTitle("", for: .idle)
        tbTransaction.mj_footer = footer
        
        lbBonus.text = String(me.bonuschain)
        getBonus()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func footerRefresh() {
        getBonus()
    }
    
    func getBonus() {
        APIManager.getBonuschainsWithUID(uid: me.uId, result: { (blist) in
            self.bonus = blist
            self.tbTransaction.reloadData()
            if self.tbTransaction.mj_footer!.isRefreshing {
                self.tbTransaction.mj_footer?.endRefreshing()
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
extension BonuschainVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bonus.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell_bonuschain")
        let lbDate = cell.viewWithTag(1) as! UILabel
        let lbAddr = cell.viewWithTag(2) as! UILabel
        let lbPrice = cell.viewWithTag(3) as! UILabel
        let one = self.bonus[indexPath.row]
        let date = Date(timeIntervalSince1970: TimeInterval(one.ts))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        lbDate.text = dateFormatter.string(from: date)
        lbAddr.text = one.oId
        lbPrice.text = String(one.amount)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

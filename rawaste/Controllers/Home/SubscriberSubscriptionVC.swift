//
//  SubscriberSubscriptionVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/10/19.
//

import UIKit
import Firebase

class SubscriberSubscriptionVC: UIViewController {
    
    enum SubMode {
        case SUBSCRIBER
        case SUBSCRIPTION
    }

    @IBOutlet weak var lbSubscribe: UILabel!
    @IBOutlet weak var lbSubscription: UILabel!
    @IBOutlet weak var tbSubscriber: UITableView!
    @IBOutlet weak var tbSubscription: UITableView!
    @IBOutlet weak var btnSubscriber: UIButton!
    @IBOutlet weak var btnSubscription: UIButton!
    
    var ref: DatabaseReference!
    let header_scriber = MJRefreshNormalHeader()
    let header_scription = MJRefreshNormalHeader()
    let footer_scription = MJRefreshAutoNormalFooter()
    let footer_scriber = MJRefreshAutoNormalFooter()
    
    var uScribers:[User] = []
    var uScriptions:[User] = []
    var range1:Int = 20
    var range0:Int = 20
    
    var mode:SubMode = .SUBSCRIBER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        header_scriber.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        header_scriber.setTitle("Wait For Loading...", for: .refreshing)
        header_scriber.setTitle("Refresh Success", for: .noMoreData)
        tbSubscriber.mj_header = header_scriber
        footer_scriber.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        footer_scriber.setTitle("Loading...", for: .pulling)
        footer_scriber.setTitle("Load Success", for: .noMoreData)
        footer_scriber.setTitle("", for: .idle)
        tbSubscriber.mj_footer = footer_scriber
        //scription
        header_scription.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh_scription))
        header_scription.setTitle("Wait For Loading...", for: .refreshing)
        header_scription.setTitle("Refresh Success", for: .noMoreData)
        tbSubscription.mj_header = header_scription
        footer_scription.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh_scription))
        footer_scription.setTitle("Loading...", for: .pulling)
        footer_scription.setTitle("Load Success", for: .noMoreData)
        footer_scription.setTitle("", for: .idle)
        tbSubscription.mj_footer = footer_scription
        
        refreshLayout()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshLayout() {
        if mode == .SUBSCRIBER {
            tbSubscriber.isHidden = false
            tbSubscription.isHidden = true
            lbSubscribe.isHidden = true
            lbSubscription.isHidden = false
            btnSubscriber.setTitle("Subscribers", for: .normal)
            btnSubscription.setTitle("", for: .normal)
            getScribers(true)
        } else {
            tbSubscriber.isHidden = true
            tbSubscription.isHidden = false
            lbSubscribe.isHidden = false
            lbSubscription.isHidden = true
            btnSubscriber.setTitle("", for: .normal)
            btnSubscription.setTitle("Subscriptions", for: .normal)
            getScriptions(true)
        }
    }
    
    @objc func headerRefresh() {
        tbSubscriber.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh() {
        range0 += 20
        getScribers(false)
    }
    
    @objc func headerRefresh_scription() {
        tbSubscription.mj_header?.endRefreshing()
    }
    
    @objc func footerRefresh_scription() {
        range1 += 20
        getScriptions(false)
    }
    
    func getScribers(_ bPage: Bool) {
        APIManager.getSubscribersWithUidAndRange(uid: me.uId, range: range0, result: { (ulist) in
            self.uScribers = ulist
            self.tbSubscriber.reloadData()
            if self.tbSubscriber.mj_footer!.isRefreshing {
                self.tbSubscriber.mj_footer?.endRefreshing()
            }
            if !bPage {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.uScribers.count - 1, section: 0)
                    self.tbSubscriber.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }
        })
    }
    
    func getScriptions(_ bPage: Bool) {
        APIManager.getSubscriptionsWithUidAndRange(uid: me.uId, range: range1, result: { (ulist) in
            self.uScriptions = ulist
            self.tbSubscription.reloadData()
            if self.tbSubscription.mj_footer!.isRefreshing {
                self.tbSubscription.mj_footer?.endRefreshing()
            }
            if !bPage {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.uScriptions.count - 1, section: 0)
                    self.tbSubscription.scrollToRow(at: indexPath, at: .top, animated: false)
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
    
    @IBAction func onSubscriberClick(_ sender: Any) {
        mode = .SUBSCRIBER
        refreshLayout()
    }
    @IBAction func onSubscriptionClick(_ sender: Any) {
        mode = .SUBSCRIPTION
        refreshLayout()
    }
    @IBAction func onSearchClick(_ sender: Any) {
    }
}

extension SubscriberSubscriptionVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tbSubscriber {
            return self.uScribers.count
        } else {
            return self.uScriptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if tableView == tbSubscriber {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell_subscriber")
            let one = self.uScribers[indexPath.row]
            let imgPhoto = cell.viewWithTag(1) as! UIImageView
            if one.photo.count > 0 {
                imgPhoto.sd_setImage(with: URL(string: one.photo), completed: nil)
            }
            let lbName = cell.viewWithTag(2) as! UILabel
            lbName.text = one.firstname + " " + one.lastname
            
        } else if tableView == tbSubscription {
            let one = self.uScriptions[indexPath.row]
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell_subscription") as! SubscriptionTVCell
            cell1.delegate = self
            cell1.index = indexPath.row
            cell1.setData(one)
            return cell1
        } else{
            cell = nil
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tbSubscriber {
            let one = self.uScribers[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            vc.mode = .OTHER
            vc.user = one
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let one = self.uScriptions[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            vc.mode = .OTHER
            vc.user = one
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SubscriberSubscriptionVC: SubscriptionTVCellDelegate{
    func onTapUnsub(index: Int) {
        let one = self.uScriptions[index]
        self.ref.child(FIREBASE_SUBSCRIPTION).child(me.uId).child(one.uId).setValue(nil)
        self.ref.child(FIREBASE_SUBSCRIBER).child(one.uId).child(me.uId).setValue(nil)
        self.uScriptions.remove(at: index)
        self.tbSubscription.reloadData()
    }
}

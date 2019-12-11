//
//  MessageVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/12/19.
//

import UIKit
import SwipeCellKit
import Firebase

class MessageVC: UIViewController {
    
    enum MsgMode {
        case MESSAGES
        case NOTIFICATIONS
    }

    @IBOutlet weak var lbMsgTab: UILabel!
    @IBOutlet weak var lbNotiTab: UILabel!
    @IBOutlet weak var btnMsgTab: UIButton!
    @IBOutlet weak var btnNotiTab: UIButton!
    @IBOutlet weak var tbMsg: UITableView!
    @IBOutlet weak var tbNoti: UITableView!
    
    var mode: MsgMode = .MESSAGES
    var contacts:[Contact] = []
    var notifications:[String] = []
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        refreshLayout()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func refreshLayout() {
        if mode == .MESSAGES {
            tbMsg.isHidden = false
            tbNoti.isHidden = true
            lbMsgTab.isHidden = true
            lbNotiTab.isHidden = false
            btnMsgTab.setTitle("Messages", for: .normal)
            btnNotiTab.setTitle("", for: .normal)
            getContacts()
        } else {
            tbMsg.isHidden = true
            tbNoti.isHidden = false
            lbMsgTab.isHidden = false
            lbNotiTab.isHidden = true
            btnMsgTab.setTitle("", for: .normal)
            btnNotiTab.setTitle("Notifications", for: .normal)
        }
    }
    
    func getContacts() {
        ref.child(FIREBASE_CONTACT).child(me.uId).queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { snapshot in
            self.contacts.removeAll()
            if snapshot.hasChildren() {
                for sh in snapshot.children.allObjects as! [DataSnapshot] {
                    let c_one = Contact.init(dic:sh.value as! Dictionary)
                    self.contacts.insert(c_one, at: 0)
                }
            }
            self.tbMsg.reloadData()
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
    @IBAction func onMsgClick(_ sender: Any) {
        mode = .MESSAGES
        refreshLayout()
    }
    @IBAction func onNotiClick(_ sender: Any) {
        mode = .NOTIFICATIONS
        refreshLayout()
    }
    
}

extension MessageVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tbMsg {
            return self.contacts.count
        } else {
            return self.notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 80
        if tableView == tbMsg {
            height = 80
        } else if tableView == tbNoti{
            height = 100
        } else {
            height = 80
        }
        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbMsg {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_message")!
            let imgPhoto = cell.viewWithTag(1) as! UIImageView
            let lbName = cell.viewWithTag(2) as! UILabel
            let lbMsg = cell.viewWithTag(3) as! UILabel
            let lbTime = cell.viewWithTag(4) as! UILabel
            let lbUnread = cell.viewWithTag(5) as! UILabel
            let one = self.contacts[indexPath.row]
            if one.user.photo.count > 0 {
                imgPhoto.sd_setImage(with: URL(string: one.user.photo), completed: nil)
            }
            lbName.text = one.user.firstname + " " + one.user.lastname
            lbMsg.text = one.message
            let delta = Int64(Date().timeIntervalSince1970) - one.timestamp
            if deltaTimeString(delta).count == 0{
                let date = Date(timeIntervalSince1970: TimeInterval(one.timestamp))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yy"
                lbTime.text = dateFormatter.string(from: date)
            } else {
                lbTime.text = deltaTimeString(delta)
            }
            if one.unread_count > 0 {
                lbUnread.text = String(one.unread_count)
                lbUnread.isHidden = false
            } else {
                lbUnread.isHidden = true
            }
            return cell
        } else if tableView == tbNoti {
            let cell_noti = tableView.dequeueReusableCell(withIdentifier: "cell_notification") as! SwipeTableViewCell
            cell_noti.delegate = self
            return cell_noti
        } else {
            var cell_nil:UITableViewCell!
            cell_nil = nil
            return cell_nil
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbMsg {
            let one = self.contacts[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.user = one.user
            self.navigationController?.pushViewController(vc, animated: true)
        } else if tableView == tbNoti {
            
        }
    }
}

extension MessageVC:SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let delAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
        }

        // customize the action appearance
        delAction.image = UIImage(named: "delete_1x")
        delAction.backgroundColor = UIColor(red: 218/255, green: 72/255, blue: 63/255, alpha: 1.0)
        delAction.textColor = UIColor.white
        delAction.font = UIFont.systemFont(ofSize: 8)
        
        let msgAction = SwipeAction(style: .default, title: "Message") { action, indexPath in
            // handle action by updating model with deletion
        }

        // customize the action appearance
        msgAction.image = UIImage(named: "message_1x")
        msgAction.backgroundColor = UIColor.white
        msgAction.textColor = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)
        msgAction.font = UIFont.systemFont(ofSize: 8)

        return [msgAction, delAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
}

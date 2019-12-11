//
//  ChatVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/12/19.
//

import UIKit
import Firebase

class ChatVC: UIViewController {

    @IBOutlet weak var tbChat: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    
    var user:User = me
    var ref:DatabaseReference!
    var roomID: String = ""
    var chats:[Chat] = []
    
    let myfont: UIFont = UIFont.systemFont(ofSize: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        refreshView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshView() {
        lbTitle.text = user.firstname + " " + user.lastname
        roomID = getChatID(me, b: user)
        ref.child(FIREBASE_CHAT).child(roomID).queryLimited(toLast: 100).observe(.childAdded, with: { (snapshot) in
            if snapshot.hasChildren() {
                let one = Chat.init(dic: snapshot.value as! [String: AnyObject])
                self.chats.append(one)
                self.tbChat.reloadData()
                DispatchQueue.main.async {
                    if self.chats.count > 5 {
                        let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
                        self.tbChat.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
            }
        })
        ref.child(FIREBASE_CONTACT).child(me.uId).child(user.uId).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.hasChildren() {
                let old = Contact.init(dic: snapshot.value as! [String: AnyObject])
                old.unread_count = 0
                old.user = self.user
                self.ref.child(FIREBASE_CONTACT).child(me.uId).child(self.user.uId).setValue(old.dic_value())
            }
        })
    }
    
    func sendMessage(_ msg: String){
        let chat_one = Chat()
        chat_one.sender = me.uId
        chat_one.message = msg
        chat_one.type = FIREBASE_TEXT
        chat_one.timestamp = Int64(Date().timeIntervalSince1970)
        chat_one.cid = ref.child(FIREBASE_CHAT).child(roomID).childByAutoId().key!
        ref.child(FIREBASE_CHAT).child(roomID).child(chat_one.cid).setValue(chat_one.dic_value())
        
        /* Add Contact*/
        ref.child(FIREBASE_CONTACT).child(user.uId).child(me.uId).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.hasChildren() {
                let old = Contact.init(dic: snapshot.value as! [String:AnyObject])
                old.unread_count = old.unread_count + 1
                old.user = me
                old.message = chat_one.message
                old.timestamp = chat_one.timestamp
                old.type = chat_one.type
                self.ref.child(FIREBASE_CONTACT).child(self.user.uId).child(me.uId).setValue(old.dic_value())
            } else {
                let old = Contact()
                old.unread_count = 1
                old.user = me
                old.message = chat_one.message
                old.timestamp = chat_one.timestamp
                old.type = chat_one.type
                self.ref.child(FIREBASE_CONTACT).child(self.user.uId).child(me.uId).setValue(old.dic_value())
            }
        })
        
        let old = Contact()
        old.unread_count = 0
        old.user = user
        old.message = chat_one.message
        old.timestamp = chat_one.timestamp
        old.type = chat_one.type
        self.ref.child(FIREBASE_CONTACT).child(me.uId).child(user.uId).setValue(old.dic_value())
        
        txtMessage.text = ""
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

extension ChatVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let one = self.chats[indexPath.row]
        let widthC = self.tbChat.frame.size.width - 132
        let msg_h = heightForView(text: one.message, font: self.myfont, width: widthC)
        if one.sender == me.uId {
            return msg_h + 44
        } else{
            return msg_h + 56
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell:UITableViewCell!
        let one = self.chats[indexPath.row]
        if one.sender == me.uId {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell_chat_my")
            let lbMsg = cell.viewWithTag(11) as! UILabel
            let lbTime = cell.viewWithTag(12) as! UILabel
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
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell_chat_other")
            let imgPhoto = cell.viewWithTag(21) as! UIImageView
            let lbName = cell.viewWithTag(22) as! UILabel
            let lbMsg = cell.viewWithTag(23) as! UILabel
            let lbTime = cell.viewWithTag(24) as! UILabel
            if self.user.photo.count > 0 {
                imgPhoto.sd_setImage(with: URL(string: self.user.photo), completed: nil)
            }
            lbName.text = self.user.firstname + " " + self.user.lastname
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
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ChatVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtMessage {
            if self.txtMessage.text!.count > 0 {
                self.sendMessage(self.txtMessage.text!)
            }
        }
        return true
    }
}

//
//  SubscriptionTVCell.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/24/19.
//

import UIKit

protocol SubscriptionTVCellDelegate {
    func onTapUnsub(index: Int)
}

class SubscriptionTVCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    var index: Int!
    var delegate: SubscriptionTVCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ data: User){
        if data.photo.count > 0 {
            imgPhoto.sd_setImage(with: URL(string: data.photo), completed: nil)
        }
        lbName.text = data.firstname + " " + data.lastname
    }
    @IBAction func onUnsubscription(_ sender: Any) {
        if delegate != nil{
            delegate.onTapUnsub(index: index)
        }
    }
    
}

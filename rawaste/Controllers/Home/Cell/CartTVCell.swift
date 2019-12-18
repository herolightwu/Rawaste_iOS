//
//  CartTVCell.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/23/19.
//

import UIKit

protocol CartTVCellDelegate {
    func onTapRemove(index: Int)
    func onTapPlus(index: Int)
    func onTapMinus(index: Int)
}

class CartTVCell: UITableViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    
    var index: Int!
    var delegate: CartTVCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ data: Product, count: Int){
        if data.images.count > 0 {
            imgPhoto.sd_setImage(with: URL(string: data.images[0]), completed: nil)
        }
        lbName.text = data.name
        lbPrice.text = String(Int(data.price))
        lbCount.text = String(count)
        APIManager.checkUserWithID(uid: data.uId, result: { user in
            if user.photo.count > 0 {
                self.imgUserPhoto.sd_setImage(with: URL(string: user.photo), completed: nil)
            }
            self.lbUserName.text = user.firstname + " " + user.lastname
        }, error: { err in
            
        })
    }
    @IBAction func onRemoveClick(_ sender: Any) {
        if delegate != nil {
            delegate.onTapRemove(index: index)
        }
    }
    @IBAction func onPlusClick(_ sender: Any) {
        if delegate != nil {
            delegate.onTapPlus(index: index)
        }
    }
    @IBAction func onMinusClick(_ sender: Any) {
        if delegate != nil {
            delegate.onTapMinus(index: index)
        }
    }
    
}

//
//  AnnounceTVCell.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/25/19.
//

import UIKit

protocol AnnounceTVCellDelegate {
    func onTapModify(index:Int)
    func onTapRemove(index:Int)
}

class AnnounceTVCell: UITableViewCell {
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    var index:Int!
    var delegate:AnnounceTVCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(_ data: Product){
        if data.images.count > 0 {
            imgPhoto.sd_setImage(with: URL(string: data.images[0]), completed: nil)
        }
        lbName.text = data.name
        lbDesc.text = data.desc
        lbPrice.text = String.init(format:"$%.2f", data.price)
    }
    @IBAction func onModifyClick(_ sender: Any) {
        if delegate != nil {
            delegate.onTapModify(index: index)
        }
    }
    @IBAction func onRemoveClick(_ sender: Any) {
        if delegate != nil {
            delegate.onTapRemove(index: index)
        }
    }
    
}

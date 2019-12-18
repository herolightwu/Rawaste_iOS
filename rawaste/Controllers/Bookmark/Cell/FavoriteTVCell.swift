//
//  FavoriteTVCell.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/25/19.
//

import UIKit

protocol FavoriteTVCellDelegate {
    func onTapDelete(index: Int)
}

class FavoriteTVCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    var index: Int!
    var delegate: FavoriteTVCellDelegate!
    
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
        lbCity.text = data.city
        lbCountry.text = data.country
        lbPrice.text = String.init(format: "$%.2f", data.price)
    }

    @IBAction func onDeleteClick(_ sender: Any) {
        if delegate != nil {
            delegate.onTapDelete(index: index)
        }
    }
}

//
//  CheckOutCell.swift
//  ListNBuy
//
//  Created by Team A on 06/02/21.
//

import UIKit

class CheckOutCell: UITableViewCell {
    
    @IBOutlet var imgProduct:UIImageView!
    @IBOutlet var lblAmount:UILabel!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblSubTitle:UILabel!
    @IBOutlet var lblQuantity:UILabel!
    @IBOutlet var btnAdd:UIButton!
    @IBOutlet var btnMinus:UIButton!
    @IBOutlet var btnDelete:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

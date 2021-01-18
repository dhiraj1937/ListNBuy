//
//  MyAccountTableViewCell.swift
//  ListNBuy
//
//  Created by Team A on 17/01/21.
//

import UIKit

class MyAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var lblHead:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgIcon:UIImageView!
    @IBOutlet weak var imgLine:UIImageView!
    @IBOutlet weak var cnstHeadHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

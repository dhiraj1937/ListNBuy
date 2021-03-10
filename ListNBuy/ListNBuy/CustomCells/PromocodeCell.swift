//
//  PromocodeCell.swift
//  ListNBuy
//
//  Created by Team A on 22/01/21.
//

import UIKit

public class MenuTableViewCell: UITableViewCell {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var img:UIImageView!
    public override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class PromocodeCell: UITableViewCell {
    @IBOutlet weak var lblCode:UILabel!
    @IBOutlet weak var lblDESC:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  WalletTransactionCell.swift
//  ListNBuy
//
//  Created by Team A on 20/01/21.
//

import UIKit

class WalletTransactionCell: UITableViewCell {
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblTrn:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblAmount:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

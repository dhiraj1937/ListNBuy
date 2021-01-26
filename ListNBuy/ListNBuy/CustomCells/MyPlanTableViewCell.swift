//
//  MyPlanTableViewCell.swift
//  ListNBuy
//
//  Created by Team A on 26/01/21.
//

import UIKit

class MyPlanTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle:UILabel?
    @IBOutlet var lblSubHeading:UILabel?
    @IBOutlet var lblOrderId:UILabel?
    @IBOutlet var lblDate:UILabel?
    @IBOutlet var lblAmount:UILabel?
    @IBOutlet var lblValid:UILabel?
    @IBOutlet var lblPaymentMethod:UILabel?
    @IBOutlet var lblPaymentStatus:UILabel?
    @IBOutlet var lblPlanStatus:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

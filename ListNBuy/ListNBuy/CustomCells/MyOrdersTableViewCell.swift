//
//  MyOrdersTableViewCell.swift
//  ListNBuy
//
//  Created by Rajesh Jayaswal on 09/02/21.
//

import UIKit

class MyOrdersTableViewCell: UITableViewCell {

    @IBOutlet var lblOrderId:UILabel?
    @IBOutlet var lblDate:UILabel?
    @IBOutlet var lblAmount:UILabel?
    @IBOutlet var lblMode:UILabel?
    @IBOutlet var lblWallet:UILabel?
    @IBOutlet var lblSuperCash:UILabel?
    @IBOutlet var lblCodPayable:UILabel?
    @IBOutlet var cnstViewCodPayableHeight:NSLayoutConstraint!
    @IBOutlet var lblAddress:UILabel?
    @IBOutlet var lblStatus:UILabel?
    @IBOutlet var btnCancel:UIButton!
    @IBOutlet var btnOrderDetail:UIButton!
    @IBOutlet var cnstViewBGHeight:NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func SetData(order:Orders){
        lblOrderId?.text = order.id
        lblDate?.text = order.placedDt
        lblAmount?.text = order.total
        lblMode?.text = order.payMethod
        lblWallet?.text = order.diductionwallet
        lblSuperCash?.text = order.diductionsuperwallet
        
        let codAmount:Double = Double(order.total)! - ( Double(order.diductionwallet)! + Double(order.diductionsuperwallet)!)
        /*if codAmount <= 0 {
            //hide cod view
            cnstViewCodPayableHeight.constant = 0
            cnstViewBGHeight.constant = cnstViewBGHeight.constant - 25
        }else{
            cnstViewCodPayableHeight.constant = 25
            lblCodPayable?.text = String(codAmount)
        }*/
        lblCodPayable?.text = String(codAmount)
        
        lblAddress?.text = order.shippingAddress
        lblStatus?.text = order.statusName
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

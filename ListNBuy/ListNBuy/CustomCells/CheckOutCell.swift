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

    public func SetData(cd:CartDetail){
        imgProduct.imageFromServerURL(urlString: cd.image)
        //lblAmount.text = String(cd.salePrice)
        lblAmount.text = Constant.isShowingSalesPrice == true ? String(cd.salePrice) : String(cd.memberPrice)
        lblTitle.text = cd.name
        lblSubTitle.text = cd.productDescription
        lblQuantity.text = cd.quantity
    }
    
    public func SetOrderData(cd:ProductInOrder){
        imgProduct.imageFromServerURL(urlString: cd.image)
        lblAmount.text = cd.name
        lblTitle.text = "Rs: "+String(cd.price)
        lblSubTitle.text = "Unit: "+cd.attributeName
        lblQuantity.text = "Quantity: "+cd.quantity
        btnAdd.isHidden = true
        btnMinus.isHidden = true
        btnDelete.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

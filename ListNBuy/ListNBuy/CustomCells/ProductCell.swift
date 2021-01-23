//
//  ProductCell.swift
//  ListNBuy
//
//  Created by Apple on 22/01/21.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet var btnLike:UIButton!
    @IBOutlet var img:UIImageView!
    @IBOutlet var btnTag:UIButton!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblRating:UILabel!
    @IBOutlet var lblDisPrice:UILabel!
    @IBOutlet var lblRealPrice:UILabel!
    @IBOutlet var lblVaiant:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func SetData(product:Product) {
        img.imageFromServerURL(urlString: product.image)
        lblRating.text = product.avgRating;
        lblTitle.text = product.name;
        lblDisPrice.text = "Rs:"+product.variation[0].salePrice.description
        let attrString = NSAttributedString(string: product.variation[0].regularPrice.description, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        lblRealPrice.attributedText = attrString
        lblRealPrice.text = "Rs:"+lblRealPrice.text!;
        lblVaiant.text = product.variation[0].attributeName;
    }
    
    public func SetData(product:NewArrivalModel) {
        img.imageFromServerURL(urlString: product.image)
        lblRating.text = product.avgRating;
        lblTitle.text = product.name;
        lblDisPrice.text = "Rs:"+product.variation[0].salePrice.description
        let attrString = NSAttributedString(string: product.variation[0].regularPrice.description, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        lblRealPrice.attributedText = attrString
        lblRealPrice.text = "Rs:"+lblRealPrice.text!;
        lblVaiant.text = product.variation[0].attributeName;
    }
}

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
        //lblDisPrice.text = "Rs:"+product.variation[0].salePrice.description
        lblDisPrice.text = Constant.isShowingSalesPrice == true ? "Rs:"+product.variation[0].salePrice.description : "Rs:"+product.variation[0].memberPrice.description
        lblRealPrice.attributedText = Helper.GetStrikeTextAttribute(txt: "Rs:"+product.variation[0].regularPrice.description);
        //lblRealPrice.text = "Rs:"+lblRealPrice.text!;
        lblVaiant.text = product.variation[0].attributeName;
    }
    public func SetProductsData(product:Products) {
        img.imageFromServerURL(urlString: product.image)
        lblRating.text = product.avgRating;
        lblTitle.text = product.name;
        //lblDisPrice.text = "Rs:"+product.variation[0].salePrice.description
        lblDisPrice.text = Constant.isShowingSalesPrice == true ? "Rs:"+product.variation[0].salePrice.description : "Rs:"+product.variation[0].memberPrice.description
        lblRealPrice.attributedText = Helper.GetStrikeTextAttribute(txt: "Rs:"+product.variation[0].regularPrice.description);
        //lblRealPrice.text = "Rs:"+lblRealPrice.text!;
        lblVaiant.text = product.variation[0].attributeName;
    }
    
}

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
    
    @IBAction func btnAddToWishlistAction(sender:UIButton){
        WishListController.addWishlistWithVCAPI(productID: sender.tag.description, vc: Constant.GetCurrentVC()) { [self] (response) in
            if response == "Success"{
                sender.isSelected = true
            }
        }
    }

    public func SetData(product:Product) {
        btnLike.tag = Int(product.id)!;
        print("wishlist count"+product.wishlist.description);
        if(product.wishlist>0){
            btnLike.isSelected=true;
        }
        else{
            btnLike.isSelected=false;
        }
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
    
    public func SetProductsModelData(product:ProductListModel) {
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

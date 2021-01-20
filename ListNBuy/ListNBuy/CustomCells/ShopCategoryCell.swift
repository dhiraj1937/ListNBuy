//
//  ShopCategoryCell.swift
//  ListNBuy
//
//  Created by Apple on 18/01/21.
//

import UIKit

class ShopCategoryCell: UICollectionViewCell {

    @IBOutlet var img:UIImageView!
    @IBOutlet var lblTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func SetData(homeCategory:HomeProductCategory){
        lblTitle.text = homeCategory.title;
        img.imageFromServerURL(urlString: homeCategory.icon)
    }

}

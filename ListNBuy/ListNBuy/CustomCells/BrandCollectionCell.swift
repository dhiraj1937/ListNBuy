//
//  BrandCollectionCell.swift
//  ListNBuy
//
//  Created by Apple on 23/01/21.
//

import UIKit

class BrandCollectionCell: UICollectionViewCell {

    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var imgView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func SetData(homeCategory:BrandModel){
        lblTitle.text = homeCategory.title;
        imgView.imageFromServerURL(urlString: homeCategory.image)
    }
}

//
//  TrendingCollectionCell.swift
//  ListNBuy
//
//  Created by Apple on 18/01/21.
//

import UIKit

class TrendingCollectionCell: UICollectionViewCell {

    @IBOutlet var img:UIImageView!
    @IBOutlet var lblTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func SetData(tredningProduct:TredningProduct){
        img.imageFromServerURL(urlString: tredningProduct.image)
        lblTitle.text = tredningProduct.name;
    }

}

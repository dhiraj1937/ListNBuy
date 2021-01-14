//
//  SocialCollectionViewCell.swift
//  ListNBuy
//
//  Created by Team A on 13/01/21.
//

import UIKit

class SocialCollectionViewCell: UICollectionViewCell {
    @IBOutlet var viewBG:UIView!
    @IBOutlet var imgBG:UIImageView!
    @IBOutlet var lblTitle:UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    public func SetData(sm:SocialSettingData){
        lblTitle.text = sm.Title;
        imgBG.imageFromServerURL(urlString: sm.Icon)
    }}

//
//  MembershipPlanCollectionViewCell.swift
//  ListNBuy
//
//  Created by Team A on 13/01/21.
//

import UIKit

class MembershipPlanCollectionViewCell: UICollectionViewCell {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblPrice:UILabel!
    @IBOutlet var lblDuration:UILabel!
    @IBOutlet var lblSubTitle:UILabel!
    @IBOutlet var txtVContent:UITextView!
    @IBOutlet var btnBuyNow:UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func SetData(mPlan:MembershipPlanData){
        lblTitle.text = mPlan.Title;
        lblPrice.text = "Rs " + mPlan.Price;
        lblDuration.text = mPlan.Duration + " Days";
        lblSubTitle.text = "   "+mPlan.SubTitle+"   ";
        txtVContent.attributedText = mPlan.Content.htmlToAttributedString;
    }
    
}
/*{
    "Id": "1",
    "Title": "Elite One - Club(1 Month)",
    "SubTitle": "1 Monthly subscription starting @ Rs 199  now @ just Rs 99 /-",
    "Content": "...",
    "Price": "99",
    "Duration": "30"
}*/

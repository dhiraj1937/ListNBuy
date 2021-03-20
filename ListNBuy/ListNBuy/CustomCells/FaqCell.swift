//
//  FaqCell.swift
//  ListNBuy
//
//  Created by Apple on 16/01/21.
//

import UIKit

class FaqCell: UITableViewCell {

    @IBOutlet var lblQues:UILabel!
    @IBOutlet var lblAns:UILabel!
    @IBOutlet var imgDirection:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func SetData(faq:FAQModel){
        lblQues.text = faq.Title;
       // lblAns.attributedText = faq.Answer.htmlToAttributedString;
       


        let mutableAttributedString:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: faq.Answer.htmlToAttributedString!)
        let range = NSRange(location: 0, length: mutableAttributedString.length)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: range)
        lblAns.attributedText = mutableAttributedString

        imgDirection?.image = UIImage.init(named: faq.Direction)
        imgDirection.setImageColor(color:  UIColor.init(hexString: "#C76C4A", alpha: 1))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

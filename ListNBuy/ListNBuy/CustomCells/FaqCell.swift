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
        lblAns.attributedText = faq.Answer.htmlToAttributedString;
        imgDirection?.image = UIImage.init(named: faq.Direction)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

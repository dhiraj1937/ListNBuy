//
//  ViewSection.swift
//  ListNBuy
//
//  Created by Apple on 18/01/21.
//

import UIKit

class ViewSection: UIView {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var contentView:UIView!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("ViewSection", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            
        }
}

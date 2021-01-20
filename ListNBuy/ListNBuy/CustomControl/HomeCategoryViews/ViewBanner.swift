//
//  ViewBanner.swift
//  ListNBuy
//
//  Created by Apple on 18/01/21.
//

import UIKit

class ViewBanner: UIView {
    @IBOutlet var contentView:UIView!
    @IBOutlet var imgBanner:UIImageView!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("ViewBanner", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            
        }
    
}

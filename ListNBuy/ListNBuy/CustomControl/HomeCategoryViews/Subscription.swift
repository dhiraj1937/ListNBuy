//
//  Subscription.swift
//  ListNBuy
//
//  Created by Apple on 23/01/21.
//

import Foundation
import UIKit
class Subscription: UIView {
    @IBOutlet private var contentView:UIView!
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("Subscription", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        }

}

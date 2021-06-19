//
//  MemberShipView.swift
//  ListNBuy
//
//  Created by Apple on 23/01/21.
//

import UIKit

class MemberShipView: UIView {
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
            Bundle.main.loadNibNamed("MemberShipView", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
           
        }
    
    @IBAction func btnGotToMemberShip(){
        if #available(iOS 13.0, *) {
            let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "MembershipPlansViewController") as MembershipPlansViewController
            vc.headertitle = "Membership Plans"
            Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
            let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "MembershipPlansViewController") as! MembershipPlansViewController
            vc.headertitle = "Membership Plans"
            Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

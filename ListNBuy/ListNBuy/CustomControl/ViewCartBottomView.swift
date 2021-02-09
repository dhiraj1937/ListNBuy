//
//  ViewCartBottomView.swift
//  ListNBuy
//
//  Created by Apple on 08/02/21.
//

import UIKit

class ViewCartBottomView: UIView {

    @IBOutlet var contentView:UIView!
    @IBOutlet var lblItems:UILabel!
    @IBOutlet var lblProce:UILabel!
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("ViewCartBottomView", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        }
    
    func SetData() {
        lblItems.text = Constant.totalItemCount.description+" Item";
        lblProce.text = "Rs."+Constant.totalAmount.description;
    }
    
    @IBAction func btn_ClickViewCart(){
        let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "CheckOutViewController") as CheckOutViewController
        Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
    }

}

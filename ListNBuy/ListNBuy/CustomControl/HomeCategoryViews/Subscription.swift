//
//  Subscription.swift
//  ListNBuy
//
//  Created by Apple on 23/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class Subscription: UIView {
    @IBOutlet private var contentView:UIView!
    @IBOutlet private var txtEmail:UITextField!
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
    
    @IBAction func btnSubscription(){
        if(txtEmail.text!.count==0){
            LPSnackbar.showSnack(title: "Please enter email.")
            return;
        }
        txtEmail.resignFirstResponder()
        GetSubscriptionAPI();
    }
    
    func GetSubscriptionAPI() {
            if KAPPDELEGATE.isNetworkAvailable(){
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
                
                let params :[String:Any] = ["Email":txtEmail.text!]
                ApiManager.sharedInstance.requestPOSTURL(Constant.sendNewsLatterURL, params: params, success: { [self](JSON) in
                    
                    let msg =  JSON.dictionary?["Message"]?.stringValue
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        txtEmail.text = "";
                        DispatchQueue.main.async {
                            HUD.flash(.progress)
                        }
                        LPSnackbar.showSnack(title:  msg ?? AlertMsg.LoginSuccess)
                        
                    }else {
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title: msg!)
                    }
                    
                },failure: { (Error) in
                    DispatchQueue.main.async {
                        HUD.flash(.error)
                        LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                    }
                })
                
            }else{
                LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            }
        
    }

}

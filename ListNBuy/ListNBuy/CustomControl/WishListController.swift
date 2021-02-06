//
//  WishListController.swift
//  Pods
//
//  Created by Team A on 02/02/21.
//

import UIKit
import LGSideMenuController
import Alamofire
import LPSnackbar
import PKHUD


class WishListController: NSObject {

    static func addWishlistAPI(productID:String,vc:ProductDetailViewController,response:@escaping (String) -> Void) {
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let userID = UserDefaults.standard.getUserID()
            var dicObj = [String:AnyObject]()
            dicObj["userId"] = userID as AnyObject
            dicObj["productId"] = productID as AnyObject
            
            ApiManager.sharedInstance.requestPOSTURL(Constant.addWishlistURL, params: dicObj, success: {
                (JSON) in
                
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title:msg!.description)
                    }
                    response("Success");
                }
                else{
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title: msg!.description)
                    }
                    response("Fail");
                }
            }, failure: { (Error) in
                DispatchQueue.main.async {
                    HUD.flash(.error)
                    LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                }
                response("Fail");
            })
        }else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            response("Fail");
        }
    }
    
    static func addCartAPI(vc:ProductDetailViewController,dicObj:[String:AnyObject]!,response:@escaping (String) -> Void) {
               
            if KAPPDELEGATE.isNetworkAvailable(){
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
                            
                ApiManager.sharedInstance.requestPOSTURL(Constant.addCartURL, params: dicObj, success: {
                    (JSON) in
                    
                    let msg =  JSON.dictionary?["Message"]
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        DispatchQueue.main.async {
                            HUD.flash(.progress)
                            LPSnackbar.showSnack(title:msg!.description)
                        }
                        response("Success");
                    }
                    else{
                        DispatchQueue.main.async {
                            HUD.flash(.progress)
                            LPSnackbar.showSnack(title: msg!.description)
                        }
                        response("Fail");
                    }
                }, failure: { (Error) in
                    DispatchQueue.main.async {
                        HUD.flash(.error)
                        LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                    }
                    response("Fail");
                })
            }else{
                LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
                response("Fail");
            }
        }
    
}

//
//  AddressController.swift
//  POD
//
//  Created by Apple on 17/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LGSideMenuController
import Alamofire
import LPSnackbar
import PKHUD

class AddressController: NSObject {
    public static var listAddress:[[String:Any]]?
    public static var listSearchAddress:[[String:Any]]?

    
    static func GetAddressAutoList(searchText:String,vc:AddAddressViewController){
        DispatchQueue.global(qos: .background).async {
          ApiManager.sharedInstance.requestGETURL(Constant.searchAddressURL+""+searchText, success: { (JSON) in
                 if((JSON.dictionary?["IsSuccess"]) != false){
                     listSearchAddress = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                 }
                vc.tblArea?.reloadData()
             },failure: {(error) in
                 print(error)
                vc.tblArea?.reloadData()
          })
            DispatchQueue.main.async {
               vc.tblArea?.reloadData()
            }
        }
        
    }
    
    static func AddAddress(vc:UIViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                HUD.show(.progress)
            
            ApiManager.sharedInstance.requestPOSTURL(Constant.addAddressURL, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                     
                        
                    }
                    else{
                        DispatchQueue.main.async {
                            HUD.flash(.error)
                            LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                        }
                    }
                }, failure: { (Error) in
                    DispatchQueue.main.async {
                        HUD.flash(.error)
                        LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                    }
                })
        }
        catch let error{
            DispatchQueue.main.async {
                HUD.flash(.error)
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
            }
        }
    }
    
    static func DeleteAddress(vc:UIViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                HUD.show(.progress)
            ApiManager.sharedInstance.requestPOSTURL(Constant.deleteAddressById, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        LPSnackbar.showSnack(title:msg!.description)
                        
                    }
                    else{
                        DispatchQueue.main.async {
                            HUD.flash(.error)
                            LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                        }
                    }
                }, failure: { (Error) in
                    DispatchQueue.main.async {
                        HUD.flash(.error)
                        LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                    }
                })
        }
        catch let error{
            DispatchQueue.main.async {
                HUD.flash(.error)
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
            }
        }
    }
    
    static func EditAddress(vc:UIViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                HUD.show(.progress)
            ApiManager.sharedInstance.requestPOSTURL(Constant.editAddressURL, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        
                      
                        
                        
                    }
                    else{
                        DispatchQueue.main.async {
                            HUD.flash(.error)
                            LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                        }
                        
                        
                    }
                HUD.flash(.progress)
                }, failure: { (Error) in
                    DispatchQueue.main.async {
                        HUD.flash(.error)
                        LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                    }
                })
        }
        catch let error{
            DispatchQueue.main.async {
                HUD.flash(.error)
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
            }
        }
    }
}

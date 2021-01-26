//
//  AddressController.swift
//  ListNBuy
//
//  Created by Team A on 23/01/21.
//

import UIKit
import LGSideMenuController
import Alamofire
import LPSnackbar
import PKHUD

class AddressController: NSObject {
    public static var listAddress:[[String:Any]]?
    public static var listSearchAddress:[[String:Any]]?

    static func GetAddressList(userID:String,vc:AddressListViewController){
        do{
            try
                HUD.show(.progress)
            listAddress = []; ApiManager.sharedInstance.requestGETURL(Constant.getAddreesByIDURL+""+userID, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listAddress = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                }
                else{
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title: msg?.stringValue ?? AlertMsg.APIFailed)
                    }
                }
                HUD.flash(.progress)
                vc.tblAdd?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                DispatchQueue.main.async {
                    HUD.flash(.error)
                    LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                }
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
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
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title:msg!.description)
                        vc.navigationController?.popViewController(animated: true)
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
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title:msg!.description)
                        AddressController.GetAddressList(userID:  dicObj!["UserId"] as! String, vc: vc as! AddressListViewController)
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
                        
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title: msg!.description)
                        vc.navigationController?.popViewController(animated: true)
                        
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
}

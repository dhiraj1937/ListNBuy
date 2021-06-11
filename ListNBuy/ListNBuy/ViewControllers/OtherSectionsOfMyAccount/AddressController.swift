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
    
    static func getWalletCash(userid:String,response:@escaping (String) -> Void) {
        
        if userid == "" {
            Constant.walletCash = "0.0"
            return
        }
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            ApiManager.sharedInstance.requestGETURL(Constant.getWalletURL+"/"+userid, success: { 
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                let wallet:WalletAmount  = try! JSONDecoder().decode(WalletAmount.self, from: jsonData!)
                Constant.walletCash = wallet.walletAmount
                Constant.superCashWalletAmount = wallet.superCashWalletAmount
               }
                response(Constant.walletCash);
                HUD.flash(.progress)
           }, failure: {  (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
            }
            response(Constant.walletCash);
            LPSnackbar.showSnack(title: AlertMsg.APIFailed)
           })
       }
        else{
            response(Constant.walletCash);
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    
    static func getPlanData(response:@escaping (String) -> Void) {
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let userID = UserDefaults.standard.getUserID()
            ApiManager.sharedInstance.requestGETURL(Constant.getUserMembershipPlan+""+userID, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                print(msg as Any)
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let listPlan:[[String:Any]]? = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                    if listPlan!.count > 0 {
                        Constant.listPlan = listPlan
                        Constant.isPlanHidden = false

                        let sortedList = listPlan?.sorted(by: { (($0 as Dictionary<String, AnyObject>)["expiryDate"] as? String)! > (($1 as Dictionary<String, AnyObject>)["expiryDate"] as? String)!})
                        print(sortedList as Any)
                        
                        let validthru = sortedList![0]["expiryDate"] as! String
                        Constant.latestPlanValidThru = validthru.substring(to: 10)
                        let currentDate = Date()
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let myDate = dateFormatter.date(from: Constant.latestPlanValidThru)
                        print("currentDate=\(String(describing: currentDate))")
                        print("myDate=\(String(describing: myDate))")
                        if currentDate.compare(myDate!) == ComparisonResult.orderedDescending {
                            //myDate is earlier than currentDate
                            Constant.isShowingSalesPrice = true
                        }else{
                            Constant.isShowingSalesPrice = false
                        }

                    }
                    HUD.flash(.progress)
                }
                response(Constant.latestPlanValidThru);
                DispatchQueue.main.async {
                    HUD.flash(.progress)
                }
            }, failure: { (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
                response(Constant.latestPlanValidThru);
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
            }
           })
       }
        else{
            response(Constant.latestPlanValidThru);
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
}

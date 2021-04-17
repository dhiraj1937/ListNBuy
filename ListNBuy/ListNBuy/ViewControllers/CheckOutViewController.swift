//
//  CheckOutViewController.swift
//  ListNBuy
//
//  Created by Team A on 04/02/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class CheckOutViewController: UIViewController {
    
    @IBOutlet weak var lblMRPVal:UILabel!
    @IBOutlet weak var lblDeliveryChargeVal:UILabel!
    @IBOutlet weak var txtFPromoCode:UITextField!
    @IBOutlet weak var btnApply:UIButton!
    @IBOutlet weak var lblApplied:UILabel!
    @IBOutlet weak var lblAppliedAmount:UILabel!
    @IBOutlet weak var lblTotalVal:UILabel!
    @IBOutlet weak var btnPayNow:UIButton!
    @IBOutlet weak var tblItemList:UITableView!
    var couponCode = ""
    var couponAmt = "0"
    var IsMonth = false;
    var walletJsonRes:JSON? = nil;
    var listProducts:[CartDetail] = [CartDetail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getCartListAPI()
    }
    
    @IBAction func btnBack(sender:UIButton){
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func btnApplyPromoCode(sender:UIButton){
        if txtFPromoCode.text?.count != 0 {
            applyCouponCodeAPI(code: txtFPromoCode.text!, total: lblTotalVal.text!)
        }
    }
   
    @IBAction func btnRemoveItem(sender:UIButton){
        let cartItem = listProducts[sender.tag]
        removeCartItemAPI(pid: cartItem.id, vid: cartItem.varID)
    }
    
    @IBAction func btnAddItemQByOne(sender:UIButton){
        
        let userPin = UserDefaults.standard.getUserPin()
        let product = listProducts[sender.tag]
        let userID = UserDefaults.standard.getUserID()
        var dic = [String:AnyObject]()
        dic["userId"] = userID as AnyObject
        dic["productId"] = product.id as AnyObject
        dic["variationId"] = product.varID as AnyObject
        let qty = Int(product.quantity)! + 1
        dic["quantity"] = qty as AnyObject
        dic["PIN"] = userPin as AnyObject
        
                   
                if KAPPDELEGATE.isNetworkAvailable(){
                    DispatchQueue.main.async {
                        HUD.show(.progress)
                    }
                                
                    ApiManager.sharedInstance.requestPOSTURL(Constant.addCartURL, params: dic, success: {
                        (JSON) in
                        print("addCartURL")
                        print(JSON)
                        let msg =  JSON.dictionary?["Message"]
                        if((JSON.dictionary?["IsSuccess"]) != false){
                            DispatchQueue.main.async {
                                HUD.flash(.progress)
                                LPSnackbar.showSnack(title:msg!.description)
                                self.getCartListAPI()
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                HUD.flash(.progress)
                                LPSnackbar.showSnack(title: msg!.description)
                            }
                        }
                    }, failure: { (Error) in
                        DispatchQueue.main.async {
                            HUD.flash(.error)
                            LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                        }
                    })
                }else{
                    LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
                }
            
    }
    @IBAction func btnRemoveItemQByOne(sender:UIButton){
        let cartItem = listProducts[sender.tag]
        removeCartItemAPI(pid: cartItem.id, vid: cartItem.varID)
    }
    @IBAction func btnPayNow(sender:UIButton){
        if #available(iOS 13.0, *) {
            let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "AddressListViewController") as AddressListViewController
            vc.headertitle = "Select Delivery Address"
            vc.totalAmount = lblTotalVal.text
            vc.cartList = listProducts
            vc.CouponCode = couponCode
            vc.CouponAmt = couponAmt;
            vc.IsMonth = IsMonth;
            if(walletJsonRes != nil){
                vc.ShippingAmt =  walletJsonRes?.dictionary?["Shipping"]!.rawString()!
                vc.Wallet =  walletJsonRes?.dictionary?["Wallet"]!.rawString()!
                vc.SuperWallet =  walletJsonRes?.dictionary?["SuperWallet"]!.rawString()!
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
            let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "AddressListViewController") as! AddressListViewController
            vc.headertitle = "Select Delivery Address"
            vc.totalAmount = lblTotalVal.text
            vc.cartList = listProducts
            vc.CouponCode = couponCode
            vc.CouponAmt = couponAmt;
            if(walletJsonRes != nil){
                vc.ShippingAmt =  walletJsonRes?.dictionary?["Shipping"]!.rawString()!
                vc.Wallet =  walletJsonRes?.dictionary?["Wallet"]!.rawString()!
                vc.SuperWallet =  walletJsonRes?.dictionary?["SuperWallet"]!.rawString()!
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }

}

extension CheckOutViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutCell")  as! CheckOutCell
        cell.SetData(cd:listProducts[indexPath.row])
        cell.btnAdd.tag = indexPath.row
        cell.btnMinus.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        return cell;
    }
    
    func getCartListAPI() {

        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let userID = UserDefaults.standard.getUserID()
            let strUrl = Constant.getCartListURL+""+userID
            print(strUrl as Any)
            ApiManager.sharedInstance.requestGETURL(strUrl, success: { [self]
                (JSON) in
                print("getCartListURL")
                print(JSON)
                let msg =  JSON.dictionary?["Message"]
                print(msg as Any)
                if((JSON.dictionary?["IsSuccess"]) != false){
                    walletJsonRes = JSON;
                    let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                    listProducts.removeAll()
                    listProducts =  try! JSONDecoder().decode([CartDetail].self, from: jsonData!)
            
                    //lblDeliveryChargeVal.text =
                    if let shipping = JSON.dictionaryObject?["Shipping"]{
                        lblDeliveryChargeVal.text = (shipping as! String)
                    }
                    
                    if let total = JSON.dictionaryObject?["Total"]{
                        
                        lblTotalVal.text = String(format: "%.2f", total as! Double)
                        Constant.totalPaybalAmount = String(total as! Double)
                    }
                    
                    if let qty = JSON.dictionaryObject?["Qty"]{
                        Constant.itemCount = String(qty as! Double)
                    }
                    
                    var mrp = 0.0
                    for item in listProducts {
                        //mrp = mrp + Double(item.quantity)! * (Constant.isShowingSalesPrice == true ? Double(item.salePrice) : Double(item.memberPrice))
                        mrp = mrp + Double(item.quantity)! *  Double(item.salePrice) 
                    }
                    lblMRPVal.text = String(format: "%.2f", mrp)
                    tblItemList.reloadData()
                    
                    if let month = JSON.dictionaryObject?["Month"]{
                        if(month as! String=="Yes"){
                            IsMonth = true;
                        }
                        else{
                            IsMonth = false;
                        }
                    }
                    
//                    if let wallet = JSON.dictionaryObject?["Wallet"]{
//                    }
//
//                    if let superWallet = JSON.dictionaryObject?["SuperWallet"]{
//                    }
                    
                    HUD.flash(.progress)
                }
                DispatchQueue.main.async {
                    HUD.flash(.progress)
                }
            }, failure: { (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
            }
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
   
    func removeCartItemAPI(pid:String,vid:String){
           
           if KAPPDELEGATE.isNetworkAvailable(){
               DispatchQueue.main.async {
                   HUD.show(.progress)
               }
               let userID = UserDefaults.standard.getUserID()
               let params :[String:Any] = ["productId":pid,
                                           "userId":userID,
                                           "variationId":vid]
               ApiManager.sharedInstance.requestPOSTURL(Constant.removeCartURL, params: params, success: {(JSON) in
                print("removeCartURL")
                print(JSON)
                   let msg =  JSON.dictionary?["Message"]?.stringValue
                   
                   if((JSON.dictionary?["IsSuccess"]) != false){
                       DispatchQueue.main.async {
                           HUD.flash(.progress)
                           LPSnackbar.showSnack(title: msg!)
                       }
                    self.getCartListAPI()
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
    
    func applyCouponCodeAPI(code:String,total:String) {
           
           if KAPPDELEGATE.isNetworkAvailable(){
               DispatchQueue.main.async {
                   HUD.show(.progress)
               }
            
            let userID = UserDefaults.standard.getUserID()

            let params :[String:Any] = ["Code":code,
                                        "userId":userID,
                                        "Total":total]
               ApiManager.sharedInstance.requestPOSTURL(Constant.applyCouponCodeURL , params: params, success: {(JSON) in
                print("applyCouponCodeURL")
                print(JSON)
                   let msg =  JSON.dictionary?["Message"]?.stringValue
                   
                   if((JSON.dictionary?["IsSuccess"]) != false){
                       DispatchQueue.main.async {
                           HUD.flash(.progress)
                           LPSnackbar.showSnack(title: msg!)
                       }
                    //if any chage required ?? otherwise
                   
                    
                    self.txtFPromoCode.isHidden = true
                    self.btnApply.isHidden = true
                    self.couponCode = (JSON.dictionary?["Code"]!.description)!
                    self.couponAmt = (JSON.dictionary?["Amount"]!.description)!
                    self.lblApplied.text = (JSON.dictionary?["Code"]!.description)! + " Applied"
                    self.lblApplied.isHidden = false
                    
                    self.lblAppliedAmount.text = "-" + (JSON.dictionary?["Amount"]!.description)!
                    self.lblAppliedAmount.isHidden = false
                    
                    self.lblTotalVal.text = JSON.dictionary?["Total"]!.description
                    
                    self.getCartListAPI()
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

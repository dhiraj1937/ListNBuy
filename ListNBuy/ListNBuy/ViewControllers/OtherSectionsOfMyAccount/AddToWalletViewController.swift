//
//  AddToWalletViewController.swift
//  ListNBuy
//
//  Created by Team A on 21/01/21.
//

import UIKit
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class AddToWalletViewController: BaseViewController {
    
    @IBOutlet weak var lblCashWallet:UILabel!
    @IBOutlet weak var txtFEnterAmount:UITextField!
    @IBOutlet weak var btnHavePromocode:UIButton!
    @IBOutlet weak var btnAddMoney:UIButton!
    @IBOutlet var tblPromoCodes:UITableView!
    
    @IBOutlet weak var lblAppliedCode:UILabel!
    @IBOutlet weak var viewApplyCode:UIView!
    @IBOutlet weak var txtFEnterCode:UITextField!
    @IBOutlet weak var btnApplycode:UIButton!

    var loginUserData : LoginUserData?
    var userid : String?
    
    var listPCodes:[PromoCode] = [PromoCode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblAppliedCode.text = ""
        let userData:Data = self.UnArchivedUserDefaultObject(key: "LoginUserData") as! Data;
        loginUserData =  try! JSONDecoder().decode(LoginUserData.self, from: userData)
        userid = loginUserData?.Id
        lblCashWallet.text = "Rs " + Constant.walletCash  
        getWalletPromoCodes()
    }
    
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHavePromocodeAction(){
        viewApplyCode.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(viewApplyCode);
    }
    
    @IBAction func btnAddMoneyAction(){
        addToWalletAPI()
    }
    
    @IBAction func btnApplyPromocodeAction(){
        applyWalletPromoCodeAPI()
    }
    @IBAction func btnClosePromocodeViewAction(){
        viewApplyCode.removeFromSuperview()
    }
}

extension AddToWalletViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromocodeCell", for: indexPath) as! PromocodeCell
        let pcode:PromoCode = listPCodes[indexPath.row]
        cell.lblCode.text = pcode.CODE
        cell.lblDESC.text = pcode.Content
        return cell
    }
    
    func getWalletPromoCodes() {
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            ApiManager.sharedInstance.requestGETURL(Constant.getWalletPromoCodeURL,  success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listPCodes  = try! JSONDecoder().decode([PromoCode].self, from: jsonData!)
                tblPromoCodes.reloadData()
                 HUD.flash(.progress)
               }
               else{
                HUD.flash(.progress)
               }
           }, failure: { [self] (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
            }
            LPSnackbar.showSnack(title: AlertMsg.APIFailed)
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    
    func validateFields(field:String) -> Bool{
        
        if field == "Amount"{
            
            if txtFEnterAmount.text!.count == 0 {
                LPSnackbar.showSnack(title: "Please enter valid amount.")
                return false
            }else{
                let strUserDeta = txtFEnterAmount.text;
                let isNotDigits = strUserDeta!.isNumeric
                    if isNotDigits {
                        LPSnackbar.showSnack(title: AlertMsg.PCheckInput)
                        return false
                    }
                let myAmount = Int(strUserDeta!) ?? 0

                if myAmount == 0 {
                    LPSnackbar.showSnack(title: AlertMsg.PCheckInput)
                    return false
                }
            }
        }
        else {
            if txtFEnterCode.text!.count == 0 {
                LPSnackbar.showSnack(title: "Please enter code.")
                return false
            }
        }
        
        return true
    }
    
    func applyWalletPromoCodeAPI() {
        //Validate Fileds
        if !validateFields(field: "CODE") { return }
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            lblAppliedCode.text = ""
            let params :[String:Any] = ["CODE":txtFEnterCode.text!,"UserId":userid!]
            
            ApiManager.sharedInstance.requestPOSTURL(Constant.applyWalletPromoCodeURL, params: params, success: {(JSON) in
                //print(JSON)
             
                let msg =  JSON.dictionary?["Message"]?.stringValue
                //print(msg as Any)
                if((JSON.dictionary?["IsSuccess"]) != false){
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                    }
                    self.lblAppliedCode.text = self.txtFEnterCode.text!
                    self.txtFEnterCode.text = ""
                    LPSnackbar.showSnack(title: msg!)
                    self.btnClosePromocodeViewAction()
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
    
    func addToWalletAPI() {
        //Validate Fileds
        if !validateFields(field: "Amount") { return }
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            //UserId
            //Role
            //Amount
            //TransactionId
            //payMethod
            //payStatus
            //CODE
            let params :[String:Any] = ["UserId":userid!,"Role":(loginUserData?.Role)!,"Amount":txtFEnterAmount.text!,"TransactionId":"abs","payMethod":"COD","payStatus":"success","CODE":lblAppliedCode.text!]
            //print(params)
            ApiManager.sharedInstance.requestPOSTURL(Constant.addToWalletURL, params: params, success: {(JSON) in
                //print(JSON)

                let msg =  JSON.dictionary?["Message"]?.stringValue
                //print(msg as Any)
                if((JSON.dictionary?["IsSuccess"]) != false){
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                    }
                    LPSnackbar.showSnack(title: msg!)
                    self.btnBack()
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

//
//  AddToWalletViewController.swift
//  ListNBuy
//
//  Created by Rajesh Jayaswal on 21/01/21.
//

import UIKit
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class AddToWalletViewController: UIViewController {
    
    @IBOutlet weak var lblCashWallet:UILabel!
    @IBOutlet weak var txtFEnterAmount:UITextField!
    @IBOutlet weak var btnHavePromocode:UIButton!
    @IBOutlet weak var btnAddMoney:UIButton!
    @IBOutlet var tblPromoCodes:UITableView!
    
    @IBOutlet weak var viewApplyCode:UIView!
    @IBOutlet weak var txtFEnterCode:UITextField!
    @IBOutlet weak var btnApplycode:UIButton!

    public let strCashAmount:String? = nil
    var loginUserData : LoginUserData?
    var userid : String?
    
    var listPCodes:[PromoCode] = [PromoCode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userData:Data = self.UnArchivedUserDefaultObject(key: "LoginUserData") as! Data;
        loginUserData =  try! JSONDecoder().decode(LoginUserData.self, from: userData)
        userid = loginUserData?.Id
        lblCashWallet.text = strCashAmount  ?? "0"
        getWalletPromoCodes()
    }
    
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHavePromocodeAction(){
        
    }
    
    @IBAction func btnAddMoneyAction(){
        
    }
    
    @IBAction func btnApplyPromocodeAction(){
        
    }
    @IBAction func btnClosePromocodeViewAction(){
        
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
}

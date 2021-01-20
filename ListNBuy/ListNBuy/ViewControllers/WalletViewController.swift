//
//  WalletViewController.swift
//  ListNBuy
//
//  Created by Rajesh Jayaswal on 19/01/21.
//

import UIKit
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class WalletViewController: UIViewController {
    @IBOutlet weak var lblCashWallet:UILabel!
    @IBOutlet weak var lblSuperCashWallet:UILabel!
    @IBOutlet weak var btnAddAmountWallet:UIButton!
    @IBOutlet var tblWalletTransaction:UITableView!
    var loginUserData : LoginUserData?
    var userid : String?
    
    var listWTransaction:[WalletTransaction] = [WalletTransaction]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userData:Data = self.UnArchivedUserDefaultObject(key: "LoginUserData") as! Data;
        loginUserData =  try! JSONDecoder().decode(LoginUserData.self, from: userData)
        if let loggedInUser = loginUserData{
            userid = loggedInUser.Id
            getWalletData()
            getWalletTran()
        }else{
            
        }
       
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension WalletViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listWTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTransactionCell", for: indexPath) as! WalletTransactionCell
        let wTrans:WalletTransaction = listWTransaction[indexPath.row]
        cell.lblDate.text = wTrans.payDate
        cell.lblTrn.text = wTrans.TrnType
        cell.lblStatus.text = wTrans.Status
        cell.lblAmount.text = wTrans.Amount
        return cell
    }
    
    func getWalletData() {
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            ApiManager.sharedInstance.requestGETURL(Constant.getWalletURL+"/"+userid!, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                let wallet:WalletAmount  = try! JSONDecoder().decode(WalletAmount.self, from: jsonData!)
                print(wallet.walletAmount)
                print(wallet.superCashWalletAmount)
                lblCashWallet.text = "Rs " + wallet.walletAmount
                lblSuperCashWallet.text = "Rs " + wallet.superCashWalletAmount
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
    
    func getWalletTran() {
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.getWalletTransactionURL+"/"+userid!, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listWTransaction  = try! JSONDecoder().decode([WalletTransaction].self, from: jsonData!)
                tblWalletTransaction.reloadData()
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

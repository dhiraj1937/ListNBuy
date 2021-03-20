//
//  WalletViewController.swift
//  ListNBuy
//
//  Created by Team A on 19/01/21.
//

import UIKit
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class WalletViewController: UIViewController {
    @IBOutlet weak var viewAccordingToPlan:UIView!
    @IBOutlet weak var lblMemberNo:UILabel!
    @IBOutlet weak var lblValidThrough:UILabel!
    @IBOutlet weak var cnstViewPlanHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCashWallet:UILabel!
    @IBOutlet weak var lblSuperCashWallet:UILabel!
    @IBOutlet weak var btnAddAmountWallet:UIButton!
    @IBOutlet var tblWalletTransaction:UITableView!
    var userid : String?
    
    var listWTransaction:[WalletTransaction] = [WalletTransaction]()

    override func viewDidLoad() {
        super.viewDidLoad()
        cnstViewPlanHeight.constant = 0
        viewAccordingToPlan.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userID = UserDefaults.standard.getUserID()
        if userID == "" {
            (KAPPDELEGATE.window!.rootViewController as! UINavigationController?)!.popToRootViewController(animated: true)
            return
        }else {
            userid = userID
            
            let strformat = "0000000000"
            let final = strformat.substring(to:strformat.count - userid!.count) + userid!
            lblMemberNo.text = final
            AddressController.getPlanData { [self] (response) in
                if Constant.isPlanHidden == true {
                    lblValidThrough.text = ""
                    cnstViewPlanHeight.constant = 0
                    viewAccordingToPlan.isHidden = true
                }else{
                    lblValidThrough.text = response
                    cnstViewPlanHeight.constant = 150
                    viewAccordingToPlan.isHidden = false
                }
                getWalletData()
                getWalletTran()
            }
            
        }
    }
    
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddAction(){
        if #available(iOS 13.0, *) {
            let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "AddToWalletViewController") as AddToWalletViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
            let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "AddToWalletViewController") as! AddToWalletViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
        cell.lblStatus.text = wTrans.Status == "1" ? "Success" : "Fail"
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
                //print(wallet.walletAmount)
                //print(wallet.superCashWalletAmount)
                lblCashWallet.text = "Rs " + wallet.walletAmount
                Constant.walletCash = wallet.walletAmount
                lblSuperCashWallet.text = "Rs " + wallet.superCashWalletAmount
                Constant.superCashWalletAmount = wallet.superCashWalletAmount
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

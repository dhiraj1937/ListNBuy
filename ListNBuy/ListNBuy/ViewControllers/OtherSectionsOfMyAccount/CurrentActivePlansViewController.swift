//
//  CurrentActivePlansViewController.swift
//  ListNBuy
//
//  Created by Team A on 26/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class CurrentActivePlansViewController: UIViewController {
    
    @IBOutlet var tblPlan:UITableView!
    var listPlan:[[String:Any]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        getPlanData()
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }

    func getPlanData(){
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let userData:Data = self.UnArchivedUserDefaultObject(key: "LoginUserData") as! Data;
            let loginUserData =  try! JSONDecoder().decode(LoginUserData.self, from: userData)
            
            ApiManager.sharedInstance.requestGETURL(Constant.getUserMembershipPlan+""+loginUserData.Id, success: { [self]
               (JSON) in
            let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listPlan = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                    tblPlan.reloadData()
                    HUD.flash(.progress)
                }
                else{
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title: msg?.stringValue ?? AlertMsg.APIFailed)
                    }
                }
           }, failure: { [self] (Error) in
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

}


extension CurrentActivePlansViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(listPlan != nil){
            return listPlan!.count
        }else{
            return 0;
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlanTableViewCell", for: indexPath) as! MyPlanTableViewCell
        let objPlan = listPlan?[indexPath.row]
        if let address = objPlan!["Title"]{
            cell.lblTitle?.text = address as? String
        }
        if let address = objPlan!["SubTitle"]{
            cell.lblSubHeading?.text = address as? String
        }
        if let address = objPlan!["transactionId"]{
            cell.lblOrderId?.text = address as? String
        }
        if let address = objPlan!["subscribedDate"]{
            cell.lblDate?.text = address as? String
        }
        if let address = objPlan!["Price"]{
            cell.lblAmount?.text = address as? String
        }
        if let address = objPlan!["expiryDate"]{
            cell.lblValid?.text = address as? String
        }
        if let address = objPlan!["payMethod"]{
            cell.lblPaymentMethod?.text = address as? String
        }
        if let address = objPlan!["payStatus"]{
            cell.lblPaymentStatus?.text = address as? String
        }
        if let address = objPlan!["Status"]{
            cell.lblPlanStatus?.text = address as! String == "1" ? "Active" : "UnActive"
        }
        
        return cell;
    }
    
}

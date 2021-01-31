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

class CurrentActivePlansViewController: BaseViewController {
    
    @IBOutlet var tblPlan:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        AddressController.getPlanData { (response) in
            if Constant.isPlanHidden == false{
                self.tblPlan.reloadData()
            }
        }
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }


}


extension CurrentActivePlansViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(Constant.listPlan != nil){
            return Constant.listPlan!.count
        }else{
            return 0;
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlanTableViewCell", for: indexPath) as! MyPlanTableViewCell
        let objPlan = Constant.listPlan?[indexPath.row]
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

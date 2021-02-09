//
//  MyOrdersVC.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class MyOrdersVC: BaseViewController {
    
    @IBOutlet var tblOrders:UITableView!
    var arrOrders:[Orders] = [Orders]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderByUserIdAPI()
    }
    
    func getOrderByUserIdAPI(){
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            //let userID = UserDefaults.standard.getUserID()
            let userID = "16"
            ApiManager.sharedInstance.requestGETURL(Constant.getOrderByUserIdURL+""+userID, success: { [self]
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                    arrOrders =  try! JSONDecoder().decode([Orders].self, from: jsonData!)
                    tblOrders.reloadData()
                    HUD.flash(.progress)
                }
                else{
                    HUD.flash(.progress)
                    LPSnackbar.showSnack(title: msg!.rawValue as! String)
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

}

extension MyOrdersVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell", for: indexPath) as! MyOrdersTableViewCell
        let objOrders:Orders = arrOrders[indexPath.row]
        cell.SetData(order: objOrders)
        cell.btnCancel.tag = indexPath.row
        cell.btnOrderDetail.tag = indexPath.row
        return cell;
    }
    
}

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
    var cancelBtnIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrderByUserIdAPI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Helper.getCartListAPI { (res) in
            if(res){
                self.AddCartView(view: self.view)
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        RemoveCart(view: self.view)
    }
    @IBAction func btnCancelOrder(sender:UIButton){
        // Create new Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to cancel your Order?", preferredStyle: .alert)
        
        self.cancelBtnIndex = sender.tag
        
        // Create OK button with action handler
        let btnYes = UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            print("YES button tapped")
            self.cancelOrderAPICall()
         })
        
        let btnNO = UIAlertAction(title: "NO", style: .default, handler: { (action) -> Void in
            print("NO button tapped")
            self.cancelBtnIndex = -1
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(btnYes)
        dialogMessage.addAction(btnNO)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    @IBAction func btnShowOrderDetail(sender:UIButton){
        let objOrder:Orders = arrOrders[sender.tag]
        let vc = KMYORDERSSTORYBOARD.instantiateViewController(identifier: "OrderDetailList") as OrderDetailList
        vc.listProducts = objOrder.products
        Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
    }
    
    func cancelOrderAPICall(){
        let objOrder:Orders = arrOrders[self.cancelBtnIndex];
        print(objOrder.id)
        self.cancelBtnIndex = -1
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
                    arrOrders.removeAll()
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

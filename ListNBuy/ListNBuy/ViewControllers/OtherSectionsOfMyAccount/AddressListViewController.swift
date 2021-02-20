//
//  AddressListViewController.swift
//  ListNBuy
//
//  Created by Team A on 23/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class AddressListViewController: UIViewController, ActionButtonDelegate {
    
    @IBOutlet var lblTitle:UILabel!
    public var headertitle:String!
    public var totalAmount:String!
    public var ShippingAmt:String!
    public var SuperWallet:String!
    public var SelectedAdd:String!
    public var Wallet:String!
    public var productList:[NotAvailableProduct] = [NotAvailableProduct]()
    public var cartList:[CartDetail] = [CartDetail]()
    @IBOutlet var tblAdd:UITableView!
    public let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = headertitle;
        if #available(iOS 10.0, *) {
            tblAdd.refreshControl = refreshControl
        } else {
            tblAdd.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshAddressData(_:)), for: .valueChanged)

        if headertitle == "Select Delivery Address"{
            tblAdd.allowsSelection = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.getAddressList()
    }
    
    @objc private func refreshAddressData(_ sender: Any) {
        // Fetch Weather Data
        self.getAddressList()
    }
    
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addEditAddress(){
        let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "AddAddressViewController") as AddAddressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAddressList(){
        let userID = UserDefaults.standard.getUserID()
        AddressController.GetAddressList(userID: userID, vc: self)
    }

}

extension AddressListViewController :
    UITableViewDelegate,UITableViewDataSource,PaymentModeButtonsDelegate,ProductUnAvailableDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(AddressController.listAddress != nil){
            return AddressController.listAddress!.count
        }
        else{
            return 0;
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableCustomCell
        cell.delegate = self
        cell.indexPath = indexPath
        let objAdd = AddressController.listAddress?[indexPath.row]
        if let address = objAdd!["Address"]{
            cell.lblAddress?.text = address as? String
        }
        if let addressIcon = objAdd!["Title"]{
            if((addressIcon as! String) == "Home"){
                cell.lblTitle?.text = "Home"
                cell.imgType?.image = UIImage.init(named: "HomeAddICon")
            }
            else if((addressIcon as! String) == "Work"){
                cell.lblTitle?.text = "Work"
                cell.imgType?.image = UIImage.init(named: "OfficeAddIcon")
            }
            else if((addressIcon as! String) != "Work" && (addressIcon as! String) != "Home"){
                cell.lblTitle?.text = addressIcon as? String
                cell.imgType?.image = UIImage.init(named: "LocationAddIcon")
            }
        }
        return cell;
    }
    
    @IBAction func btnAddNewAddress_Click(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        controller.IsEdit = false;
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func EditTapped(at index: IndexPath) {
        let dicAddObj = AddressController.listAddress![index.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddAddressViewController") as! AddAddressViewController
        controller.IsEdit = true;
        controller.editDic = dicAddObj as [String : AnyObject]; self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func DeleteTapped(at index: IndexPath) {
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        if #available(iOS 13.0, *) {
            deleteAlert.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let dicAddObj = AddressController.listAddress![index.row]
            var dicObj = [String:AnyObject]()
            
            if let customarID = dicAddObj["UserId"]{
                dicObj["UserId"] = customarID as AnyObject
            }
            if let Id = dicAddObj["Id"]{
                dicObj["Id"] = Id as AnyObject
            }
            AddressController.DeleteAddress(vc: self, dicObj: dicObj)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicAddObj = AddressController.listAddress![indexPath.row];
        //print(dicAddObj)
        SelectedAdd = dicAddObj["Address"] as! String;
        if headertitle == "Select Delivery Address"{
            
            Helper.CheckAvailableProdcutAPI(pincode: dicAddObj["Pincode"] as! String) {(productList) in
                if(productList.count>0){
                    self.productList = productList;
                    self.openProductUnAvailableForSelectedArea()
                }
                else{
                    self.openPaymentOption()
                }
            }
        }
    }
    func openPaymentOption(){
        let vc = PaymentModeViewController.init(nibName: "PaymentModeViewController", bundle: nil)
        vc.delegate = self
        vc.amount = totalAmount
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    func btnSelectedWithMode(mode:String) {
        print("selected mode =\(mode)")
        createOrderAPI(paymentmode:mode)
    }
    
    func openProductUnAvailableForSelectedArea(){
        let vc = ProductUnAvailableViewController.init(nibName: "ProductUnAvailableViewController", bundle: nil)
        vc.delegate = self
        vc.listProducts = productList
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func btnGoBackSelected() {
        self.btnBack()
    }
    
    func createOrderAPI(paymentmode:String){
        let creatOrder:CreateOrder!
        if paymentmode == "POD" {
            //POD
            creatOrder = CreateOrder.init(products: cartList, shippingAddress: SelectedAdd, shipping:ShippingAmt, couponCode: "", couponAmount: "0", lat: Constant.currentLocation.coordinate.latitude.description, lng: Constant.currentLocation.coordinate.longitude.description, payMethod: "COD", userID: UserDefaults.standard.getUserID(), role: UserDefaults.standard.getUserROLE(), diductionwallet: "0.0", diductionsuperwallet: "0.0", dDt: Date.init().description)
            
        }else{
            //Online
            creatOrder = CreateOrder.init(products: cartList, shippingAddress: SelectedAdd, shipping: "", couponCode: "", couponAmount: "0", lat: Constant.currentLocation.coordinate.latitude.description, lng: Constant.currentLocation.coordinate.longitude.description, payMethod: "ONLINE", userID: UserDefaults.standard.getUserID(), role: UserDefaults.standard.getUserROLE(), diductionwallet: "0.0", diductionsuperwallet: "0.0", dDt: Date.init().description)
        }
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            let userID = UserDefaults.standard.getUserID()
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let orderJsonData = try! encoder.encode(creatOrder);
            print(String(data: orderJsonData, encoding: .utf8)!)
            let orderJson = String(data: orderJsonData, encoding: .utf8)!
            let params :[String:Any] = ["order":orderJson] //Dhiraj ??
            ApiManager.sharedInstance.requestPOSTURL(Constant.createOrderURL, params: params, success: {(JSON) in
                print(JSON)
                let msg =  JSON.dictionary?["Message"]?.stringValue
                if((JSON.dictionary?["IsSuccess"]) != false){
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title: msg!)
                        //Dhiraj ??
                    }
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

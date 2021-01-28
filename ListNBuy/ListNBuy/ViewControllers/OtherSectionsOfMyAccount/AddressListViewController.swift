//
//  AddressListViewController.swift
//  ListNBuy
//
//  Created by Team A on 23/01/21.
//

import UIKit

class AddressListViewController: BaseViewController, ActionButtonDelegate {

    @IBOutlet var tblAdd:UITableView!
    public let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        tblAdd.rowHeight = UITableView.automaticDimension
//        tblAdd.estimatedRowHeight = 130
//        tblAdd.reloadData()
        if #available(iOS 10.0, *) {
            tblAdd.refreshControl = refreshControl
        } else {
            tblAdd.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshAddressData(_:)), for: .valueChanged)
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
    UITableViewDelegate,UITableViewDataSource{
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicAddObj = AddressController.listAddress![indexPath.row];
        //print(dicAddObj)
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
    
    
}

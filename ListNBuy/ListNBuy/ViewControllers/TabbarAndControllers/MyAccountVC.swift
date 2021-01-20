//
//  MyAccountVC.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit


class MyAccountVC: UIViewController {
    @IBOutlet weak var tblSetting: UITableView!
    var ListArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dic0:[String: String] = ["Head" : "Profile","Title" : "My Profile","Img" : "face","Showline":"0"]
        ListArray.add(dic0)
        
        let dic1:[String: String] = ["Head" : "","Title" : "My Orders","Img" : "ic_orders","Showline":"1"]
        ListArray.add(dic1)

        let dic2:[String: String] = ["Head" : "Save Address","Title" : "Edit Address","Img" : "address","Showline":"0"]
        ListArray.add(dic2)
        
        let dic3:[String: String] = ["Head" : "Plan","Title" : "My Plan","Img" : "myplan","Showline":"0"]
        ListArray.add(dic3)
        
        let dic4:[String: String] = ["Head" : "Wallet","Title" : "My Wallet","Img" : "mywallet","Showline":"1"]
        ListArray.add(dic4)
        
        let dic5:[String: String] = ["Head" : "","Title" : "Logout","Img" : "logout","Showline":"0"]
        ListArray.add(dic5)
    }

}

extension MyAccountVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTableViewCell", for: indexPath) as! MyAccountTableViewCell
        let dict:[String:String] = ListArray[indexPath.row] as! [String : String];
        cell.lblHead.text = dict["Head"]
        if dict["Head"] == "" {
            cell.cnstHeadHeight.constant = 0
        }else{
            cell.cnstHeadHeight.constant = 20
        }
        if let imageName = dict["Img"]{
            cell.imgIcon.image = UIImage.init(named:imageName)
        }
        cell.lblTitle.text = dict["Title"]
                
        if dict["Showline"] == "1" {
            cell.imgLine.isHidden = false
        }else{
            cell.imgLine.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 0
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict:[String:String] = ListArray[indexPath.row] as! [String : String];
        print(dict["Title"]!)
        
        if dict["Title"] == "My Profile" {
            let vc = KMYACCOUNTSTORYBOARD.instantiateViewController(identifier: "profileViewController") as ProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if dict["Title"] == "My Orders" {
            
            
        }
        else if dict["Title"] == "Save Address" {

            
        }
        else if dict["Title"] == "My Plan" {

            
        }else if dict["Title"] == "My Wallet" {
            let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "WalletViewController") as WalletViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if dict["Title"] == "Logout" {
//                       guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                           let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return  }
//                    self.navigationController?.popToViewController(window.rootViewController!, animated: true)
            }
    }
    
}


//
//  MenuViewController.swift
//  ListNBuy
//
//  Created by Apple on 10/03/21.
//

import Foundation
class Menu: NSObject {
    
    //MARK: Properties
    var name: String
    var icon: String
    var isSelected: Bool
    
    init(name: String, icon: String, isSelected:Bool) {
        self.icon = icon;
        self.name = name;
        self.isSelected = isSelected;
    }
}

class MenuViewController: UIViewController {
    
    public  var menuList:[Menu] = [Menu]()
    @IBOutlet var imgLogo : UIImageView!
    
    @IBOutlet var tblMenu:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        SetMenu()
        imgLogo.center = CGPoint(x: (self.view.frame.size.width-50)/2, y: imgLogo.center.y) ;
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print(self.view.frame.size.width)
        imgLogo.center = CGPoint(x: (self.view.frame.size.width-50)/2, y: imgLogo.center.y) ;
        
//        let ind:Int = Constant.globalTabbar!.selectedIndex
//         if ind == 4 {
//            menuList.forEach{$0.isSelected = false}
//            menuList[1].isSelected = true
//            tblMenu.reloadData()
//         }else if ind == 0 || ind == 1 || ind == 2 || ind == 3 {
//                menuList.forEach{$0.isSelected = false}
//                menuList[0].isSelected = true
//                tblMenu.reloadData()
//         }
    }
    
    func SetMenu(){
        menuList.removeAll()
        menuList.append(Menu.init(name: "Home", icon: "HomeMenu", isSelected:true))
        menuList.append(Menu.init(name: "My Account", icon: "MyAccount", isSelected:false))
        menuList.append(Menu.init(name: "Membership Plan", icon: "MemberShip-1", isSelected:false))
        menuList.append(Menu.init(name: "Social Media", icon: "SocialMedia", isSelected:false))
        menuList.append(Menu.init(name: "Contact Us", icon: "ContactUs", isSelected:false))
        menuList.append(Menu.init(name: "FAQs", icon: "FAQ", isSelected:false))
        menuList.append(Menu.init(name: "About Us", icon: "AboutUs", isSelected:false))
        menuList.append(Menu.init(name: "Privacy Policy", icon: "PrivacyPolicy", isSelected:false))
        menuList.append(Menu.init(name: "Terms and Condition", icon: "TC", isSelected:false))
        menuList.append(Menu.init(name: "Share", icon: "Share", isSelected:false))
        menuList.append(Menu.init(name: "Ratings", icon: "Rating", isSelected:false))
        
    }

}

extension MenuViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        let menu = menuList[indexPath.row]
        cell.img.image = UIImage.init(named: menu.icon);
        cell.lblTitle.text = menu.name;
        if(menu.isSelected){
            cell.img.setImageColor(color: UIColor.purple)
            cell.lblTitle.textColor = UIColor.purple;
            cell.viewContainer.backgroundColor = UIColor.lightGray;
            cell.viewContainer.alpha = 0.2;
        }
        else{
            cell.img.setImageColor(color: UIColor.darkGray);
            cell.lblTitle.textColor = UIColor.darkGray;
            cell.viewContainer.backgroundColor = UIColor.clear;
            cell.layer.backgroundColor = UIColor.clear.cgColor
        }
        return cell;
    }
    

    func setBG(indexPath: IndexPath){
        menuList.forEach{$0.isSelected = false}
        menuList[indexPath.row].isSelected = true
        tblMenu.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setBG(indexPath: indexPath)
        
        if(indexPath.row == 0){
            Constant.globalTabbar?.navigationController?.popToRootViewController(animated:false)
            Constant.globalTabbar?.selectedIndex = 0
        }
        else if(indexPath.row == 1){
            Constant.globalTabbar?.navigationController?.popToRootViewController(animated:false)
            Constant.globalTabbar?.selectedIndex = 4
        }
        else if(indexPath.row == 2){
            if #available(iOS 13.0, *) {
                let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "MembershipPlansViewController") as MembershipPlansViewController
                vc.headertitle = "Membership Plans"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "MembershipPlansViewController") as! MembershipPlansViewController
                vc.headertitle = "Membership Plans"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.row==3){
            if #available(iOS 13.0, *) {
                let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "SocialViewController") as SocialViewController
                vc.headertitle = "Social Media"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
                vc.headertitle = "Social Media"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.row == 4){
            if #available(iOS 13.0, *) {
                let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "ContactUsViewController") as ContactUsViewController
                vc.slug = "contact-us";
                vc.headertitle = "Contact US"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                vc.slug = "contact-us";
                vc.headertitle = "Contact US"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.row == 5){
            if #available(iOS 13.0, *) {
                let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "FAQsViewController") as FAQsViewController
                vc.headertitle = "FAQs"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "FAQsViewController") as! FAQsViewController
                vc.headertitle = "FAQs"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.row == 6){
           
            if #available(iOS 13.0, *) {
                let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "OtherInfoViewController") as OtherInfoViewController
                vc.slug = "about-us";
                vc.headertitle = "About Us"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "OtherInfoViewController") as! OtherInfoViewController
                vc.slug = "about-us";
                vc.headertitle = "About Us"
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.row == 7){
            if #available(iOS 13.0, *) {
                let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "OtherInfoViewController") as OtherInfoViewController
                vc.slug = "privacy-policy";
                vc.headertitle = "Privacy policy";
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "OtherInfoViewController") as! OtherInfoViewController
                vc.slug = "privacy-policy";
                vc.headertitle = "Privacy policy";
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.row == 8){
            if #available(iOS 13.0, *) {
                let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "OtherInfoViewController") as OtherInfoViewController
                vc.slug = "terms-and-conditions";
                vc.headertitle = "Terms Conditions";
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "OtherInfoViewController") as! OtherInfoViewController
                vc.slug = "terms-and-conditions";
                vc.headertitle = "Terms Conditions";
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.row == 9){
            let items = ["Install List n Buy application at: https://apps.apple.com/us/app/google/id\(YOUR_APP_STORE_ID)"]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            Constant.globalTabbar?.present(ac, animated: true)
        }
        else if(indexPath.row == 10){
            self.openAppStoreReview()
        }
        if(indexPath.row != 9 && indexPath.row != 10){
            TabbarViewController.revealController?.revealToggle(UIButton.init())
        }
            
    }
    
    func openAppStoreReview() {
        let appId = YOUR_APP_STORE_ID
        let appStoreReviewUrl = "itms-apps://itunes.apple.com/app/id\(appId)?mt=8&action=write-review"
        guard let url = URL(string: appStoreReviewUrl) else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

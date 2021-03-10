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
    
    init(name: String, icon: String) {
        self.icon = icon;
        self.name = name;
    }
}

class MenuViewController: UIViewController {
    
    public  var menuList:[Menu] = [Menu]()
    @IBOutlet var tblMenu:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        SetMenu()
        // Do any additional setup after loading the view.
    }
    
    func SetMenu(){
        menuList.removeAll()
        menuList.append(Menu.init(name: "Home", icon: "HomeMenu"))
        menuList.append(Menu.init(name: "My Account", icon: "MyAccount"))
        menuList.append(Menu.init(name: "Membership Plan", icon: "MemberShip-1"))
        menuList.append(Menu.init(name: "Social Media", icon: "SocialMedia"))
        menuList.append(Menu.init(name: "Contact Us", icon: "ContactUs"))
        menuList.append(Menu.init(name: "FAQs", icon: "FAQ"))
        menuList.append(Menu.init(name: "About Us", icon: "AboutUs"))
        menuList.append(Menu.init(name: "Privacy Policy", icon: "PrivacyPolicy"))
        menuList.append(Menu.init(name: "Terms and Condition", icon: "TC"))
        menuList.append(Menu.init(name: "Share", icon: "Share"))
        menuList.append(Menu.init(name: "Ratings", icon: "Rating"))
        
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
        if(indexPath.row == 0){
            //cell.lblTitle.textColor = Constant.appColor;
            cell.contentView.backgroundColor = UIColor.init(hexString: "#DCDCDC");
        }
        else{
            cell.lblTitle.textColor = UIColor.darkGray;
            cell.contentView.backgroundColor = UIColor.clear;
            cell.layer.backgroundColor = UIColor.clear.cgColor
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            
        }
        else if(indexPath.row == 1){
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
                vc.slug = "terms-conditions";
                vc.headertitle = "Terms Conditions";
                Constant.globalTabbar?.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "OtherInfoViewController") as! OtherInfoViewController
                vc.slug = "terms-conditions";
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
        TabbarViewController.revealController?.revealToggle(UIButton.init()) 
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

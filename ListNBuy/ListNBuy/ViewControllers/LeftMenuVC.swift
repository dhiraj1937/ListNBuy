//
//  LeftMenuVC.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit

class LeftMenuVC: UIViewController {
    
    let leftMenuControllers = ["homeVC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func MenuOptions(_ sender: UIButton) {
        DispatchQueue.main.async {
            
            if sender.tag == 0 {// Home
                //Home only hide this menu
            }
            else if sender.tag == 1 {// My Account
                self.hideLeftView(nil)
                Constant.globalTabbar?.selectedIndex = 4
            }
            else if sender.tag == 2 {//Membership Plans
                if #available(iOS 13.0, *) {
                    let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "MembershipPlansViewController") as MembershipPlansViewController
                    vc.headertitle = "Membership Plans"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Fallback on earlier versions
                    let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "MembershipPlansViewController") as! MembershipPlansViewController
                    vc.headertitle = "Membership Plans"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            else if sender.tag == 3 {//Social Media
                if #available(iOS 13.0, *) {
                    let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "SocialViewController") as SocialViewController
                    vc.headertitle = "Social Media"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Fallback on earlier versions
                    let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "SocialViewController") as! SocialViewController
                    vc.headertitle = "Social Media"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            else if sender.tag == 4 {//Contact US
                if #available(iOS 13.0, *) {
                    let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "ContactUsViewController") as ContactUsViewController
                    vc.slug = "contact-us";
                    vc.headertitle = "Contact US"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Fallback on earlier versions
                    let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                    vc.slug = "contact-us";
                    vc.headertitle = "Contact US"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
            else if sender.tag == 5 {//FAQs
                if #available(iOS 13.0, *) {
                    let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "FAQsViewController") as FAQsViewController
                    vc.headertitle = "FAQs"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Fallback on earlier versions
                    let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "FAQsViewController") as! FAQsViewController
                    vc.headertitle = "FAQs"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            else if sender.tag == 6 {//About US
                if #available(iOS 13.0, *) {
                    let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "OtherInfoViewController") as OtherInfoViewController
                    vc.slug = "about-us";
                    vc.headertitle = "About Us"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Fallback on earlier versions
                    let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "OtherInfoViewController") as! OtherInfoViewController
                    vc.slug = "about-us";
                    vc.headertitle = "About Us"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
            else if sender.tag == 7 {
                if #available(iOS 13.0, *) {
                    let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "OtherInfoViewController") as OtherInfoViewController
                    vc.slug = "privacy-policy";
                    vc.headertitle = "Privacy policy";
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Fallback on earlier versions
                    let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "OtherInfoViewController") as! OtherInfoViewController
                    vc.slug = "privacy-policy";
                    vc.headertitle = "Privacy policy";
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            else if sender.tag == 8 {
                if #available(iOS 13.0, *) {
                    let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "OtherInfoViewController") as OtherInfoViewController
                    vc.slug = "terms-and-conditions";
                    vc.headertitle = "Terms Conditions";
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Fallback on earlier versions
                    let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "OtherInfoViewController") as! OtherInfoViewController
                    vc.slug = "terms-and-conditions";
                    vc.headertitle = "Terms Conditions";
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            else if sender.tag == 9 {//share
                //no ctrl just open share
                let items = ["Install List n Buy application at: https://apps.apple.com/us/app/google/id\(YOUR_APP_STORE_ID)"]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            }
            else if sender.tag == 10 {//Ratings
                // no ctrl just open app in app store
                self.openAppStoreReview()
            }
            else {
                //let newViewController = KMENUCONTROLLERSSTORYBOARD.instantiateViewController(withIdentifier: self.leftMenuControllers[sender.tag])
                //self.navigationController?.show(newViewController, sender: nil)
            }
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


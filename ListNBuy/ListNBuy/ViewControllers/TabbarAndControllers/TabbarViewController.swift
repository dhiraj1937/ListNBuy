//
//  TabbarViewController.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNVC = KHOMESTORYBOARD.instantiateViewController(withIdentifier: "homeNVC") as! UINavigationController
        let homeIcon = UITabBarItem(title: "Home", image: UIImage(named: "i_home.png"), selectedImage: UIImage(named: "i_home.png"))
        homeNVC.tabBarItem = homeIcon
        
        let myOrdersNVC = KMYORDERSSTORYBOARD.instantiateViewController(withIdentifier: "myOrdersNVC") as! UINavigationController
        let orderIcon = UITabBarItem(title: "My Orders", image: UIImage(named: "i_order.png"), selectedImage: UIImage(named: "i_order.png"))
        myOrdersNVC.tabBarItem = orderIcon
        
        let offersNVC = KOFFERSSTORYBOARD.instantiateViewController(withIdentifier: "offersNVC") as! UINavigationController
        let offerIcon = UITabBarItem(title: "Offers", image: UIImage(named: "i_offer.png"), selectedImage: UIImage(named: "i_offer.png"))
        offersNVC.tabBarItem = offerIcon
        
        let wishlistNVC = KWISHLISTSTORYBOARD.instantiateViewController(withIdentifier: "wishlistNVC") as! UINavigationController
        let wishIcon = UITabBarItem(title: "Wishlist", image: UIImage(named: "i_wishlist.png"), selectedImage: UIImage(named: "i_wishlist.png"))
        wishlistNVC.tabBarItem = wishIcon
        
        let myAccountNVC = KMYACCOUNTSTORYBOARD.instantiateViewController(withIdentifier: "myAccountNVC") as! UINavigationController
        let accIcon = UITabBarItem(title: "My Account", image: UIImage(named: "i_profile.png"), selectedImage: UIImage(named: "i_profile.png"))
        myAccountNVC.tabBarItem = accIcon
        
        self.viewControllers = [homeNVC , myOrdersNVC , offersNVC , wishlistNVC, myAccountNVC]
        self.selectedIndex = 0
        self.view.tintColor = UIColor.init(hexString: "#953A9D", alpha: 1)
        Constant.globalTabbar = self
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true;
    }
}

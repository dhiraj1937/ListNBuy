//
//  AppDelegate.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit
import IQKeyboardManagerSwift
import Reachability
import LGSideMenuController

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var reachability: Reachability = try! Reachability()

    var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        let isUserLoggedIN = UserDefaults.standard.isLoggedIn()
        if isUserLoggedIN == true {
            
                let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
                controller.leftViewWidth = 300;
                controller.leftViewPresentationStyle = LGSideMenuPresentationStyle(rawValue: 0)!
                let nav = UINavigationController.init(rootViewController:controller)
                nav.setNavigationBarHidden(true, animated: true)
                window?.rootViewController = nav;
            Helper.getCartListAPI();
        }
        else{
            let controller = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController.init(rootViewController: controller)
            nav.setNavigationBarHidden(true, animated: true)
            window?.rootViewController = nav;
        }
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        return true
    }
}
extension AppDelegate {
    
    public func isNetworkAvailable() -> Bool {
        reachability.connection != .unavailable
    }
}

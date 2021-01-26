//
//  AppDelegate.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit
import IQKeyboardManagerSwift
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var reachability: Reachability = try! Reachability()

    var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        let controller = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nav = UINavigationController.init(rootViewController: controller)
        nav.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = nav;
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        return true
    }
}
extension AppDelegate {
    
    public func isNetworkAvailable() -> Bool {
        reachability.connection != .unavailable
    }
}

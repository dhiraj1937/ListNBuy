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
import FBSDKCoreKit
import GoogleSignIn
import CoreLocation
@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    lazy var reachability: Reachability = try! Reachability()
    var locationManager: CLLocationManager!
    var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        GIDSignIn.sharedInstance().clientID = "973257019249-o8o9ebdrephr8cn10ajicdjvr7nmhtg1.apps.googleusercontent.com"
       
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        let isUserLoggedIN = UserDefaults.standard.isLoggedIn()
        if isUserLoggedIN == true {
            
//                let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
//                controller.leftViewWidth = 250;
//                controller.leftViewPresentationStyle = LGSideMenuPresentationStyle(rawValue: 0)!
//                let nav = UINavigationController.init(rootViewController:controller)
//                nav.setNavigationBarHidden(true, animated: true)
            
            
            var menuVC:MenuViewController? = nil;
            var tabvc:TabbarViewController? = nil;
            if #available(iOS 13.0, *) {
                tabvc = KMAINSTORYBOARD.instantiateViewController(identifier:"TabbarViewController") as TabbarViewController
                menuVC = KMAINSTORYBOARD.instantiateViewController(identifier:"MenuViewController") as MenuViewController
            } else {
                // Fallback on earlier versions
                tabvc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "TabbarViewController") as? TabbarViewController
                menuVC = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
            }
            let frontNavigation = UINavigationController.init(rootViewController: tabvc!)
            let rearNavigation = UINavigationController.init(rootViewController: menuVC!)
            frontNavigation.isNavigationBarHidden = true;
            rearNavigation.isNavigationBarHidden = true;
            let swvc:SWRevealViewController = SWRevealViewController.init(rearViewController: rearNavigation, frontViewController: frontNavigation)
            //swvc.rearViewRevealWidth = self.view.frame.size.width-50
            
            let nav = UINavigationController.init(rootViewController:swvc)
            nav.setNavigationBarHidden(true, animated: true)
            window?.rootViewController = nav;
            
        }
        else{
            let controller = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController.init(rootViewController: controller)
            nav.setNavigationBarHidden(true, animated: true)
            window?.rootViewController = nav;
        }
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
            if (CLLocationManager.locationServicesEnabled())
            {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        let location = locations.last! as CLLocation
        /* you can use these values*/
        Constant.currentLocation = location
       
    }
}
extension AppDelegate {
    
    public func isNetworkAvailable() -> Bool {
        reachability.connection != .unavailable
    }
}

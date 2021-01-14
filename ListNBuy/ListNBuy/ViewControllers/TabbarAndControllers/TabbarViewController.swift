//
//  TabbarViewController.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    @IBOutlet var tabbarView: UIView!
    @IBOutlet weak var item0: UIButton!
    @IBOutlet weak var item1: UIButton!
    @IBOutlet weak var item2: UIButton!
    @IBOutlet weak var item3: UIButton!
    @IBOutlet weak var item4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNVC = KHOMESTORYBOARD.instantiateViewController(withIdentifier: "homeNVC") as! UINavigationController
        let myOrdersNVC = KMYORDERSSTORYBOARD.instantiateViewController(withIdentifier: "myOrdersNVC") as! UINavigationController
        let offersNVC = KOFFERSSTORYBOARD.instantiateViewController(withIdentifier: "offersNVC") as! UINavigationController
        let wishlistNVC = KWISHLISTSTORYBOARD.instantiateViewController(withIdentifier: "wishlistNVC") as! UINavigationController
        let myAccountNVC = KMYACCOUNTSTORYBOARD.instantiateViewController(withIdentifier: "myAccountNVC") as! UINavigationController
        
        self.viewControllers = [homeNVC , myOrdersNVC , offersNVC , wishlistNVC, myAccountNVC]
        self.selectedIndex = 0
        self.item0.isSelected = true
        
        self.tabbarView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 94, width: UIScreen.main.bounds.size.width, height: 94)
        self.view.addSubview(self.tabbarView)
        Constant.globalTabbar = self
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true;
    }
    
    @IBAction func tabItemPressed(_ sender: UIButton) {
        reset()
        self.selectedIndex = sender.tag
        sender.isSelected = true
    }
    
    func reset() {
        self.item0.isSelected = false
        self.item1.isSelected = false
        self.item2.isSelected = false
        self.item3.isSelected = false
        self.item4.isSelected = false
    }
    
//    func selectIndex0() {
//        reset()
//        self.selectedIndex = 0
//        item0.isSelected = true
//    }
    

}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: Double(size.width), height: Double(size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

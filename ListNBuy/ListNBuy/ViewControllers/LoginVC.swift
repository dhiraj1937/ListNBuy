//
//  LoginVC.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit
import LGSideMenuController
import Alamofire
import LPSnackbar
import PKHUD

class LoginVC: UIViewController,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var txtFMobileOrEmail: RJBorderedTF!
    @IBOutlet weak var txtFOTP: RJBorderedTF!
    @IBOutlet weak var btnRequestOTPAndContinue: UIButton!
    @IBOutlet weak var viewOTPSection :UIView!
    @IBOutlet weak var cnstOTPSection: NSLayoutConstraint!
    @IBOutlet weak var cnstContainerView: NSLayoutConstraint!
    

    var isHideOTPSection = true
    var strOTP:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let isUserLoggedIN = UserDefaults.standard.isLoggedIn()
        if isUserLoggedIN == true {
            self.navigatToHome()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtFOTP.text = "";
        txtFMobileOrEmail.text = "";
        viewOTPSection.isHidden = true
        cnstOTPSection.constant = 0
        cnstContainerView.constant = 355
    }
    
    @IBAction func skip(_ sender: UIButton) {
        self.navigatToHome()
    }
    
    func navigatToHome() {
        
        DispatchQueue.main.async {
            
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
            swvc.delegate = self;
            swvc.rearViewRevealWidth = self.view.frame.size.width-50
            self.navigationController?.pushViewController(swvc, animated: true);
            
            
            
//            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
//            controller.leftViewWidth = 250;
//            controller.leftViewPresentationStyle = LGSideMenuPresentationStyle(rawValue: 0)!
//
//            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func validateFields() -> Bool{
        
        if txtFMobileOrEmail.text!.count == 0 {
            LPSnackbar.showSnack(title: AlertMsg.enterEmailIDOrMobileNo)
            return false
        }else{
            let strUserDeta = txtFMobileOrEmail.text;
            if strUserDeta!.contains("@") {
                //email
                let isValidEmail = strUserDeta!.validateEmail()
                if !isValidEmail {
                    LPSnackbar.showSnack(title: AlertMsg.PCheckInput)
                    return false
                }
            }else{
                
                let isNotDigits = strUserDeta!.isNumeric
                if isNotDigits {
                    LPSnackbar.showSnack(title: AlertMsg.PCheckInput)
                    return false
                }
                
                //mobile
                if txtFMobileOrEmail.text!.count != 10 {
                    LPSnackbar.showSnack(title: AlertMsg.mobileNoLength)
                    return false}
            }
        }
        return true
    }
    @IBAction func loginAPI(_ sender: Any) {
        if isHideOTPSection == true {
            sendLoginOTP()
        }else{
            self.matchOTPAndCallUserLoginAPI();
        }
    }
    
    @IBAction func resendOTP(_ sender: Any) {
        sendLoginOTP()
    }
    func sendLoginOTP() {
        //Validate Fileds
        if !validateFields() { return }
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let params :[String:Any] = ["E_O_P":txtFMobileOrEmail.text!]
            ApiManager.sharedInstance.requestPOSTURL(Constant.sendLoginOTPUrl, params: params, success: {(JSON) in
                print(JSON)
                let msg =  JSON.dictionary?["Message"]?.stringValue
               // print(msg as Any)
                
                if((JSON.dictionary?["IsSuccess"]) != false){
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                    }
                    self.isHideOTPSection = false;
                    self.btnRequestOTPAndContinue.setTitle("CONTINUE", for: .normal)
                    self.viewOTPSection.isHidden = false
                    self.cnstContainerView.constant = 433
                    self.cnstOTPSection.constant = 78
                    if let strotp = JSON.dictionary?["OTP"]?.stringValue {
                        self.strOTP = strotp
                    }
                    LPSnackbar.showSnack(title: msg!)
                }else {
                    HUD.flash(.progress)
                    LPSnackbar.showSnack(title: msg!)
                }
            },failure: { (Error) in
                DispatchQueue.main.async {
                    HUD.flash(.error)
                    LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                }
            })
            
        }else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }

    }
    
    func matchOTPAndCallUserLoginAPI() {
        
        if self.strOTP == txtFOTP.text {
            
            if KAPPDELEGATE.isNetworkAvailable(){
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
                
                let params :[String:Any] = ["E_O_P":txtFMobileOrEmail.text!, "OTP": strOTP]
                ApiManager.sharedInstance.requestPOSTURL(Constant.loginUrl, params: params, success: {(JSON) in
                    print(JSON)
                    
                    let msg =  JSON.dictionary?["Message"]?.stringValue
                    //print(msg as Any)
                    
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                        self.ArchivedUserDefaultObject(obj:jsonData as Any, key: "LoginUserData")
                        
                        UserDefaults.standard.setLoggedIn(value: true)
                        let dicUserInfo = (JSON.dictionaryObject!["ResponseData"]) as? [String:Any];
                        //print(dicUserInfo!["Id"] as Any)
                        if let userid = dicUserInfo!["Id"]{
                            UserDefaults.standard.setUserID(value:userid as! String)
                        }
                        
                        if let userRole = dicUserInfo!["Role"]{
                            UserDefaults.standard.setUserROLE(value:userRole as! String)
                        }
                        
                        DispatchQueue.main.async {
                            HUD.flash(.progress)
                        }
                        LPSnackbar.showSnack(title:  msg ?? AlertMsg.LoginSuccess)
                        self.navigatToHome()
                    }else {
                        HUD.flash(.progress)
                        LPSnackbar.showSnack(title: msg!)
                    }
                    
                },failure: { (Error) in
                    DispatchQueue.main.async {
                        HUD.flash(.error)
                        LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                    }
                })
                
            }else{
                LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            }
        }
        
    }
    

}


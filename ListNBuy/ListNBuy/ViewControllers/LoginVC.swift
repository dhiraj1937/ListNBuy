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
import Firebase
import FirebaseCrashlytics

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
        Crashlytics.crashlytics().log("View loaded")
        Crashlytics.crashlytics().setCustomValue(42, forKey: "MeaningOfLife")
        Crashlytics.crashlytics().setCustomValue("Test value", forKey: "last_UI_action")
        Crashlytics.crashlytics().setUserID("123456789")

        let userInfo = [
          NSLocalizedDescriptionKey: NSLocalizedString("The request failed.", comment: ""),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("The response returned a 404.", comment: ""),
          NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Does this page exist?", comment:""),
          "ProductID": "123456",
          "UserID": "Jane Smith"
        ]
        let error = NSError(domain: NSURLErrorDomain, code: -1001, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtFOTP.text = "";
        txtFMobileOrEmail.text = "";
        viewOTPSection.isHidden = true
        cnstOTPSection.constant = 0
        cnstContainerView.constant = 310//355
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor.black
//        }
        
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
            swvc.rearViewRevealWidth = self.view.frame.size.width - self.view.frame.size.width/2
            self.navigationController?.pushViewController(swvc, animated: true);
            
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
                    self.cnstContainerView.constant = 385//433
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


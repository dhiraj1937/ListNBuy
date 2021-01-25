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

class LoginVC: UIViewController {
    
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
        viewOTPSection.isHidden = true
        cnstOTPSection.constant = 0
        cnstContainerView.constant = 355
    }
    
    @IBAction func skip(_ sender: UIButton) {
        self.navigatToHome()
    }
    
    func navigatToHome() {
        
        DispatchQueue.main.async {
            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            controller.leftViewWidth = 300;
            controller.leftViewPresentationStyle = LGSideMenuPresentationStyle(rawValue: 0)!
            
            let navigation = UINavigationController.init(rootViewController: controller)
            navigation.navigationBar.isHidden = true
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
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
                /*
                 {
                 "IsSuccess": true,
                 "Message": "OTP sent sucessfully in your mobile or email 9926722087",
                 "OTP": 933144,
                 "E_O_P": "9926722087",
                 "ResponseData": []
                 }*/
                
                let msg =  JSON.dictionary?["Message"]?.stringValue
                print(msg as Any)
                
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
                    print(msg as Any)
                    
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                       
                        self.ArchivedUserDefaultObject(obj:jsonData as Any, key: "LoginUserData")
                        
//                        let userData:Data = self.UnArchivedUserDefaultObject(key: "LoginUserData") as! Data;
//
//                        let loginUserData : LoginUserData =  try! JSONDecoder().decode(LoginUserData.self, from: userData)
                        
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


//
//  SignUP.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit
import LGSideMenuController
import Alamofire
import LPSnackbar
import PKHUD

class SignUP: UIViewController {
    @IBOutlet weak var txtFMobile: RJBorderedTF!
    @IBOutlet weak var txtFOTP: RJBorderedTF!
    @IBOutlet weak var btnSignUpContinue: UIButton!
    @IBOutlet weak var btnResendOTP: UIButton!

    @IBOutlet weak var viewOTPSection :UIView!
    @IBOutlet weak var cnstOTPSection: NSLayoutConstraint!
    @IBOutlet weak var cnstContainerView: NSLayoutConstraint!

    var isHideOTPSection = true
    var strOTP:String = ""
    var strSignBy:String = "1"
    var strMobile:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewOTPSection.isHidden = true
        cnstOTPSection.constant = 0
        cnstContainerView.constant = 342
    }
    
    
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigatToNext() {
        
        DispatchQueue.main.async {
            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            controller.leftViewWidth = 300;
            controller.leftViewPresentationStyle = LGSideMenuPresentationStyle(rawValue: 0)!
            
            self.navigationController?.pushViewController(controller, animated: true)
            
            
        }
    }
    
    func validateFields() -> Bool{
        
        if txtFMobile.text!.count == 0 {
            LPSnackbar.showSnack(title: AlertMsg.enterMobileNo)
            return false
        }
        //mobile
        if txtFMobile.text!.count != 10 {
            LPSnackbar.showSnack(title: AlertMsg.mobileNoLength)
            return false}
        
        return true
    }
    
    @IBAction func SignUPAPI(_ sender: Any) {
        
        if isHideOTPSection == true {
            regOTP(strURL: Constant.sendRegistrationOTPUrl)
        }else if isHideOTPSection == false && btnSignUpContinue.titleLabel?.text == "CONTINUE"{
            self.matchOTPAndverifyAPI();
        }else if isHideOTPSection == false && btnSignUpContinue.titleLabel?.text == "SUBMIT"{
            self.callUserRegistrationAPI()
        }
        

    }
    @IBAction func resendOTP(_ sender: Any) {
        regOTP(strURL: Constant.reSendRegistrationOTPUrl)
    }
    
    func regOTP(strURL:String) {
        
        //Validate Fileds
        if !validateFields() { return }
        let params :[String:Any] = ["E_O_P":txtFMobile.text!]
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            ApiManager.sharedInstance.requestPOSTURL(strURL, params: params, success: {(JSON) in
                
                let msg =  JSON.dictionary?["Message"]?.stringValue
                //print(msg as Any)
                
                if((JSON.dictionary?["IsSuccess"]) != false){
                   // print(JSON)
                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                    }
                    self.isHideOTPSection = false;
                    self.btnSignUpContinue.setTitle("CONTINUE", for: .normal)
                    self.viewOTPSection.isHidden = false
                    self.cnstContainerView.constant = 420
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
                    LPSnackbar.showSnack(title:AlertMsg.APIFailed)
                }
            })
            
        }else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    
   
    func matchOTPAndverifyAPI() {
       
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
        
        if self.strOTP == txtFOTP.text {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateTextFields()
            }
            
            
            
//            if KAPPDELEGATE.isNetworkAvailable(){
//                DispatchQueue.main.async {
//                    HUD.show(.progress)
//                }
//
//                let params :[String:Any] = ["E_O_P":txtFMobile.text!, "OTP": strOTP]
//                ApiManager.sharedInstance.requestPOSTURL(Constant.verifyRegistrationOTPURL, params: params, success: {(JSON) in
//                    print(JSON)
//
//                    let msg =  JSON.dictionary?["Message"]?.stringValue
//                    print(msg as Any)
//
//                    if((JSON.dictionary?["IsSuccess"]) != false){
//                        DispatchQueue.main.async {
//                            HUD.flash(.progress)
//                        }
//                        self.btnSignUpContinue.setTitle("SUBMIT", for: .normal)
//                        self.strMobile = self.txtFMobile.text!
//                        self.txtFMobile.placeholder = "Enter Name"
//                        self.txtFOTP.placeholder = "Enter Email ID"
//                        self.txtFMobile.text = ""
//                        self.txtFOTP.text = ""
//                        self.btnResendOTP.isHidden = true
//                        if let signBy = JSON.dictionary?["SignBy"]?.stringValue {
//                            self.strSignBy = signBy
//                        }
//                        LPSnackbar.showSnack(title: msg ?? AlertMsg.APIFailed)
//                    }else {
//                        HUD.flash(.progress)
//                        LPSnackbar.showSnack(title: msg ?? AlertMsg.APIFailed)
//                    }
//                },failure: { (Error) in
//                    DispatchQueue.main.async {
//                        HUD.flash(.error)
//                        LPSnackbar.showSnack(title:AlertMsg.APIFailed)
//                    }
//                })
//
//            }else{
//                LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
//            }
        }else{
            LPSnackbar.showSnack(title: "OTP Not matched")
        }
        
    }
    
    func updateTextFields(){
    self.btnSignUpContinue.setTitle("SUBMIT", for: .normal)
    self.strMobile = self.txtFMobile.text!
    self.txtFMobile.placeholder = "Enter Name"
    self.txtFOTP.placeholder = "Enter Email ID"
    self.txtFMobile.text = ""
    self.txtFOTP.text = ""
    self.btnResendOTP.isHidden = true
    HUD.flash(.progress)
    }
    
    func callUserRegistrationAPI() {
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let params :[String:Any] = ["SignBy": strSignBy, "Name": txtFMobile.text!, "Email": txtFOTP.text!, "Phone": strMobile]
            ApiManager.sharedInstance.requestPOSTURL(Constant.registrationUrl, params: params, success: {(JSON) in
                //print(JSON)
                
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

                    DispatchQueue.main.async {
                        HUD.flash(.progress)
                    }
                    LPSnackbar.showSnack(title:  msg ?? "Success!!")
                    self.navigatToNext()
                    
                }else {
                    HUD.flash(.progress)
                    LPSnackbar.showSnack(title:  msg!)
                }
            },failure: { (Error) in
                DispatchQueue.main.async {
                    HUD.flash(.error)
                    LPSnackbar.showSnack(title:AlertMsg.APIFailed)
                }
            })
            
        }else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }

}


//
//  LoginController.swift
//  ListNBuy
//
//  Created by Apple on 10/02/21.
//

import Foundation
import FacebookLogin
import FacebookCore
import GoogleSignIn
import SwiftyJSON
import PKHUD
import LPSnackbar
import LGSideMenuController

extension LoginVC : GIDSignInDelegate{
    
    
    //MARK: Google SignIn Completion Handler
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
        // Perform any operations on signed in user here.
        //let userId = user.userID                  // For client-side use only!
        //let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        //let profileImageURL = user.profile.imageURL(withDimension: 100)
        let email = user.profile.email
        //let socialModel = SocialRegisterModel(SignBy: "3", Firstname: fullName! , Lastname: fullName! , Email: email! , SocialId: userId!)
        let params :[String:Any] = ["SignBy": "3", "Name": fullName, "Email": email, "Phone": ""]
        callUserRegistrationAPI(params: params)
        
    }
    
    
    @IBAction func LoginWithFaceBook(){
        do{
            let loginManager = LoginManager()
            loginManager.authType = .reauthorize
            loginManager.logOut()
            loginManager.logIn(
                permissions: [.publicProfile,.email],
                viewController: self
            ) { result in
                switch result {
                case .cancelled: break
                case .failed( _): break
                case .success( _, _, _):
                    DispatchQueue.main.async {
                        HUD.show(.progress)
                    }
                    if let accessToken = AccessToken.current?.tokenString {
                        self.fetchUserProfile(loginToken: accessToken)
                    }
                }
            }
        }
        catch _{
            //Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc)
            //vc.removeSpinner(onView: vc.view)
        }
    }
    
    @IBAction func LoginWithGoogle(){
        do{
            GIDSignIn.sharedInstance()?.presentingViewController = self;
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.signIn()
        }
        catch let error{
            //Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc)
            //vc.removeSpinner(onView: vc.view)
        }
    }
    
    func callUserRegistrationAPI(params:[String:Any]) {
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }

            ApiManager.sharedInstance.requestPOSTURL(Constant.registrationUrl, params: params, success: {(JSON) in
                let msg =  JSON.dictionary?["Message"]?.stringValue
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
    
    func navigatToNext() {
        
        DispatchQueue.main.async {
            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            controller.leftViewWidth = 250;
            controller.leftViewPresentationStyle = LGSideMenuPresentationStyle(rawValue: 0)!
            
            self.navigationController?.pushViewController(controller, animated: true)
            
            
        }
    }
    
    func fetchUserProfile(loginToken:String)
    {
        
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480),location"],tokenString: loginToken,version: nil,httpMethod: HTTPMethod.get)
        graphRequest.start(completionHandler: { [self] (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error took place: \(error)")
                DispatchQueue.main.async {
                    HUD.flash(.progress)
                }
                LPSnackbar.showSnack(title: error!.localizedDescription)
            }
            else
            {
                
                print("Print entire fetched result: \(JSON(result!))")
                var userInfo:[String:AnyObject] = [String:AnyObject]()
                let pictureData = JSON(result!).dictionaryObject!["picture"] as! NSDictionary
                let data = JSON(pictureData).dictionaryObject!["data"] as! NSDictionary
                let pictureUrlString  = data["url"] as! String
                let pictureUrl = NSURL(string: pictureUrlString)
                let imageData:NSData = NSData(contentsOf: pictureUrl as! URL)!
                if(imageData != nil){
                    userInfo["ProfileImage"] = imageData
                }
                else{
                    
                    //userInfo["ProfileImage"] = Data.init() as AnyObject
                }
                userInfo["SocialId"] = JSON(result!).dictionaryObject!["id"] as AnyObject
                userInfo["Name"] = JSON(result!).dictionaryObject!["name"] as AnyObject
                userInfo["Email"] = JSON(result!).dictionaryObject!["email"] as AnyObject
                userInfo["Phone"] = "" as AnyObject
                userInfo["Address"] = JSON(result!).dictionaryObject!["location"] as AnyObject
                userInfo["OTP"] = "" as AnyObject?
                userInfo["Password"] = ""  as AnyObject?
                userInfo["SignBy"] = "2" as AnyObject?
                let params :[String:Any] = ["SignBy": "2", "Name": userInfo["Name"] , "Email": userInfo["Email"], "Phone": ""]
                callUserRegistrationAPI(params: params)
                
            }
            //vc.removeSpinner(onView: vc.view)
        })
    }
    
}

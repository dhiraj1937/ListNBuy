//
//  ProfileViewController.swift
//  ListNBuy
//
//  Created by Team A on 18/01/21.
//

import UIKit
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class ProfileViewController: UIViewController {
    @IBOutlet weak var txtFName:UITextField!
    @IBOutlet weak var txtFEmail:UITextField!
    @IBOutlet weak var txtFPhone:UITextField!
    var userid : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = UserDefaults.standard.getUserID()
        if userID == "" {
            (KAPPDELEGATE.window!.rootViewController as! UINavigationController?)!.popToRootViewController(animated: true)
            return
        }else {
            userid = userID
        }
        getUserData()
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }

    func getUserData(){
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.userByUserIdURL+"/"+userid!, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                let user:LoginUserData  = try! JSONDecoder().decode(LoginUserData.self, from: jsonData!)
                //print(user.Name)
                //print(user.Email)
                //print(user.Phone)
                self.txtFName.text = user.Name
                self.txtFEmail.text = user.Email
                self.txtFPhone.text = user.Phone

                 HUD.flash(.progress)
               }
               else{
                HUD.flash(.progress)
               }
           }, failure: { [self] (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
            }
            LPSnackbar.showSnack(title: AlertMsg.APIFailed)
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

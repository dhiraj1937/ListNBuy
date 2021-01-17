//
//  WhatsAppOrderViewController.swift
//  ListNBuy
//
//  Created by Apple on 17/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class WhatsAppOrderViewController: UIViewController {

    @IBOutlet var txtPin:UITextField!
    var navigation:UINavigationController!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }

   @IBAction func btnSubmit_Click(){
           
        if(txtPin.text?.count==0){
            LPSnackbar.showSnack(title: "Please enter pin code.")
            return
        }
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            ApiManager.sharedInstance.requestGETURL(Constant.getWhatsAppAvailibilityURL+"/"+txtPin.text!, success: { [self]
               (JSON) in
                let msg =  JSON["Message"].string
               if((JSON.dictionary?["IsSuccess"]) != false){
                LPSnackbar.showSnack(title: msg!)
                 HUD.flash(.progress)
               }
               else{
                HUD.flash(.progress)
                LPSnackbar.showSnack(title: msg!)
               }
              self.dismiss(animated: true, completion: nil)
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

}

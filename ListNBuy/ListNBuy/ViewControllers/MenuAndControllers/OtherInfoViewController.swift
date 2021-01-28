//
//  OtherInfoViewController.swift
//  ListNBuy
//
//  Created by Apple on 11/01/21.
//

import Foundation
import UIKit
import Alamofire
import LPSnackbar
import PKHUD

class OtherInfoViewController: BaseViewController {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var txtView:UITextView!
    public var slug:String!;
    public var headertitle:String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = headertitle;
        GetOtherInfoData(slug: slug);
    }
    
    
    
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func GetOtherInfoData(slug:String){
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.slugUrl+"/"+slug, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                  
                txtView.attributedText = JSON.dictionary?["ResponseData"]!["Content"].rawString()?.htmlToAttributedString
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
}

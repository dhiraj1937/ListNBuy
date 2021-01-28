//
//  ContactUsViewController.swift
//  ListNBuy
//
//  Created by Team A on 12/01/21.
//

import Foundation
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON


class ContactUsViewController: BaseViewController {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var btnMobile:UIButton!
    @IBOutlet var btnWeb:UIButton!
    @IBOutlet var btnEmail:UIButton!

    public var headertitle:String!;
    public var slug:String!;
    var testCons : ContactUsModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = headertitle;
        getContactUsData(slug: slug);
    }
    
    
    
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getContactUsData(slug:String){
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.slugUrl+"/"+slug, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                self.testCons   =  try! JSONDecoder().decode(ContactUsModel.self, from: jsonData!)
               
                if self.testCons != nil {
                    self.SetUp()
                }
                HUD.flash(.progress)
               }
               else{
                HUD.flash(.progress)
               }
           }, failure: { [self] (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
            }
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    public func SetUp(){
    btnMobile.setTitle(testCons?.Phone!, for: .normal)
    btnEmail.setTitle(testCons?.Email!, for: .normal)
    btnWeb.setTitle(testCons?.Web!, for: .normal)
    }
    
    @IBAction func phoneAction(_sender:UIButton){
        let phone = (_sender.titleLabel?.text)!
        if let url = URL(string: "tel://\(String(describing: phone))"),
          UIApplication.shared.canOpenURL(url) {
             if #available(iOS 10, *) {
               UIApplication.shared.open(url, options: [:], completionHandler:nil)
              } else {
                  UIApplication.shared.openURL(url)
              }
          } else {
                   // add error message here
          }
        
    }
    @IBAction func emailAction(_sender:UIButton){
        let email = (_sender.titleLabel?.text)!
        if let url = URL(string: "mailto:\(String(describing: email))") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func webAction(_sender:UIButton){
        var weburl:String = (_sender.titleLabel?.text)!
        let hasHttp = weburl.hasPrefix("http")
        if hasHttp == false {
            weburl = "http://" + weburl
        }
        guard let url = URL(string: weburl) else {
            return
            }
            UIApplication.shared.open(url, completionHandler: { success in
                if success {
                    print("opened")
                } else {
                    print("failed")
                }
            })
    }
  
}

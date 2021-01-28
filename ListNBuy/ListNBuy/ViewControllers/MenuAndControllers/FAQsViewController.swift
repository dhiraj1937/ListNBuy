//
//  FAQsViewController.swift
//  ListNBuy
//
//  Created by Team A on 14/01/21.
//

import Foundation
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class FAQsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqCell") as! FaqCell
        cell.SetData(faq: faqList[indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FaqCell
        let faq  = faqList[indexPath.row];
        if(!faq.IsShow){
            faq.Answer = faq.Content!;
            faq.Direction = "ic_expand_less_black";
            faq.IsShow = true;
        }
        else{
            faq.Answer = "";
            faq.Direction = "ic_expand_more_black";
            faq.IsShow = false;
        }
        cell.layoutSubviews();
        tblFAQ.reloadData()
    }
    
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var tblFAQ:UITableView!
    var faqList:[FAQModel] = [FAQModel]();
    public var headertitle:String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = headertitle;
        tblFAQ.estimatedRowHeight = 67.0
        tblFAQ.rowHeight = UITableView.automaticDimension
        GetFAQData();
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func GetFAQData(){
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.faqUrl, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                 faqList = try! JSONDecoder().decode([FAQModel].self, from: jsonData!)
                 tblFAQ.reloadData()
                 HUD.flash(.progress)
               }
               else{
                HUD.flash(.progress)
               }
           }, failure: {
            [self] (Error) in
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

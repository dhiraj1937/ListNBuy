//
//  MembershipPlansViewController.swift
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

class MembershipPlansViewController: BaseViewController {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var collectionView:UICollectionView!
    var listMPlan:[MembershipPlanData] = [MembershipPlanData]()
    public var headertitle:String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = headertitle;
        getMembershipPlanData()
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenWidth = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 25, left: 20, bottom: 5, right: 15)
        layout.itemSize = CGSize(width: screenWidth-60, height: collectionView!.frame.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        collectionView.reloadData();
    }
}
extension MembershipPlansViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listMPlan.count == 0 {
                self.collectionView.setEmptyMessage("No Data Found.")
            } else {
                self.collectionView.restore()
            }

        return 1;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listMPlan.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MembershipPlanCollectionViewCell", for: indexPath) as! MembershipPlanCollectionViewCell
        let mplan = listMPlan[indexPath.section]
        cell.SetData(mPlan: mplan)
        cell.btnBuyNow.tag = indexPath.section
        cell.btnBuyNow.addTarget(self, action:#selector(btnBuyNowAction(sender:)),
                                 for: UIControl.Event.touchUpInside)
        let userID = UserDefaults.standard.getUserID()
        if(userID == ""){
            cell.btnBuyNow.isHidden = true
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mp = listMPlan[indexPath.row]
    }
    
    func getMembershipPlanData(){
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.membershipPlanUrl, success: { [self]
               (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listMPlan = try! JSONDecoder().decode([MembershipPlanData].self, from: jsonData!)
                collectionView.reloadData()
                HUD.flash(.progress)
            }
            else{
                HUD.flash(.progress)
                LPSnackbar.showSnack(title: msg!.rawValue as! String)
               }
           }, failure: { [self] (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
            }
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
     
    @objc func btnBuyNowAction(sender: UIButton) {
         //print(sender.tag)
        let mp = listMPlan[sender.tag]
            
            if KAPPDELEGATE.isNetworkAvailable(){
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
                
                let userID = UserDefaults.standard.getUserID()
            
                let params :[String:Any] = ["planId":mp.Id,
                                            "customerId":userID,
                                            "payMethod":"COD",
                                            "price":mp.Price,
                                            "duration":mp.Duration,
                                            "transactionId":"abs"]
                //print(params)
                ApiManager.sharedInstance.requestPOSTURL(Constant.addMembershipURL, params: params, success: {(JSON) in
                    //print(JSON)
                    
                    let msg =  JSON.dictionary?["Message"]?.stringValue
                    //print(msg as Any)
                    
                    if((JSON.dictionary?["IsSuccess"]) != false){
        
                        DispatchQueue.main.async {
                            HUD.flash(.progress)
                            LPSnackbar.showSnack(title: msg!)
                        }
                                    
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


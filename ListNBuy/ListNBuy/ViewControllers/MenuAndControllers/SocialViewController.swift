//
//  SocialViewController.swift
//  ListNBuy
//
//  Created by Team A on 13/01/21.
//

import Foundation
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class SocialViewController: BaseViewController {
    public var headertitle:String!;
    @IBOutlet var lblTitle:UILabel!

    @IBOutlet var collectionView:UICollectionView!
    var listSM:[SocialSettingData] = [SocialSettingData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = headertitle;
        getSocialList()
    }

    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenWidth = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
        layout.itemSize = CGSize(width: screenWidth/2-10, height: screenWidth/2-10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
    }
}
extension SocialViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listSM.count == 0 {
                self.collectionView.setEmptyMessage("No Data Found.")
            } else {
                self.collectionView.restore()
            }

        return listSM.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialCollectionViewCell", for: indexPath) as! SocialCollectionViewCell
        let sm = listSM[indexPath.row]
        cell.SetData(sm: sm)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sm = listSM[indexPath.row]
        //print(sm.Link)
        let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "WebViewController") as WebViewController
        vc.urlString = sm.Link
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getSocialList(){
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.socialSettingsUrl, success: { [self]
               (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listSM = try! JSONDecoder().decode([SocialSettingData].self, from: jsonData!)
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
    
}

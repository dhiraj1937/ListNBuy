//
//  WishlistVC.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON


class WishlistVC: BaseViewController {
    
    @IBOutlet var collectionView:UICollectionView!
    var listWish:[[String:Any]]?

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
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWishlList()
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

extension WishlistVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(listWish != nil){
            return listWish!.count
        }else{
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishListCollectionViewCell", for: indexPath) as! WishListCollectionViewCell
        let product = listWish?[indexPath.row]
        
        if let name = product?["name"]{
            cell.lblName.text = name as? String
        }
        
        if let img = product?["Image"]{
            cell.imgViewProduct.imageFromServerURL(urlString: img as! String)
        }
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action:#selector(btnRemoveAction(sender:)),
                                 for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = listWish?[indexPath.row]
        print(product as Any)
        if let pid = product?["id"]{
            if #available(iOS 13.0, *) {
                let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductDetailViewController") as ProductDetailViewController
                vc.productId = pid as? String
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = KHOMESTORYBOARD.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                vc.productId = pid as? String
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        }
    }
    
    @objc func btnRemoveAction(sender: UIButton) {
        let product = listWish?[sender.tag]
        var wl_id = "" as String
        if let wid = product?["wishlistId"] {
            wl_id = (wid as? String)!
        }
        
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let params :[String:Any] = ["Id":wl_id]
            ApiManager.sharedInstance.requestPOSTURL(Constant.removeWishlistURL, params: params, success: {(JSON) in
                //print(JSON)
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    HUD.flash(.progress)
                    LPSnackbar.showSnack(title: msg!.stringValue)
                   // self.collectionView.reloadData()
                    self.getWishlListAfterDelete()
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
    
    func getWishlList(){
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }

           ApiManager.sharedInstance.requestGETURL(Constant.getWishlistURL+""+userid!, success: { [self]
               (JSON) in
            let msg =  JSON.dictionary?["Message"]
            listWish = [[String:Any]]();
            if((JSON.dictionary?["IsSuccess"]) != false){
                listWish = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                collectionView.reloadData()
                HUD.flash(.progress)
            }
            else{
                HUD.flash(.progress)
                LPSnackbar.showSnack(title: msg!.rawValue as! String)
                collectionView.reloadData()
               }
           }, failure: { [self] (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                collectionView.reloadData()
            }
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    
    func getWishlListAfterDelete(){
           
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }

           ApiManager.sharedInstance.requestGETURL(Constant.getWishlistURL+""+userid!, success: { [self]
               (JSON) in
            let msg =  JSON.dictionary?["Message"]
            listWish = [[String:Any]]();
            if((JSON.dictionary?["IsSuccess"]) != false){
                listWish = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                collectionView.reloadData()
                HUD.flash(.progress)
            }
            else{
                HUD.flash(.progress)
                //LPSnackbar.showSnack(title: msg!.rawValue as! String)
                collectionView.reloadData()
               }
           }, failure: { [self] (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
                //LPSnackbar.showSnack(title: AlertMsg.APIFailed)
                collectionView.reloadData()
            }
           })
       }
        else{
            //LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    
}


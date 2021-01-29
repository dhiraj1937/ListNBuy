//
//  SearchListViewController.swift
//  ListNBuy
//
//  Created by Apple on 29/01/21.
//

import Foundation
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
class SearchListViewController: UIViewController {
    @IBOutlet var collectionView:UICollectionView!
    var listProducts:[Product] = [Product]()
    var searchText:String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: screenWidth/2.0, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        collectionView.reloadData();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetSearchProductList();
    }
    
    @IBAction func btnBack(sender:UIButton){
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func GetSearchProductList() {
        
            if KAPPDELEGATE.isNetworkAvailable(){
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
                let params :[String:Any] = ["userid":UserDefaults.standard.getUserID(), "q":searchText as Any]
                ApiManager.sharedInstance.requestPOSTURL(Constant.GetSearchProductURL, params: params, success: { [self](JSON) in
                   
                    let msg =  JSON.dictionary?["Message"]?.stringValue
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                        listProducts = try! JSONDecoder().decode([Product].self, from: jsonData!)
                        collectionView.reloadData()
                        DispatchQueue.main.async {
                            HUD.flash(.progress)
                        }
                        LPSnackbar.showSnack(title:  msg ?? AlertMsg.LoginSuccess)
                        
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

extension SearchListViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listProducts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.SetData(product: listProducts[indexPath.row])
        return cell;
    }
    
    
}

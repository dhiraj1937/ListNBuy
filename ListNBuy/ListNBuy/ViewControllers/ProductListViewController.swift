//
//  ProductListViewController.swift
//  ListNBuy
//
//  Created by Rajesh Jayaswal on 03/02/21.
//

import UIKit
import UIKit
import Alamofire
import LPSnackbar
import PKHUD

class ProductListViewController: UIViewController {
    @IBOutlet var imgViewBanner: UIImageView!
    @IBOutlet var collectionViewProduct:UICollectionView!
    @IBOutlet var collectionViewCategory:UICollectionView!
    public var parentCategoryId:String!
    public var strImgBanner:String!
    
    var listProducts:[Product] = [Product]()
    var listCategory:[HomeParentCategoryModel] = [HomeParentCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgViewBanner.imageFromServerURL(urlString: strImgBanner);
        let screenWidth = collectionViewProduct!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: screenWidth/2.0, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionViewProduct!.collectionViewLayout = layout
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionViewProduct.register(nib, forCellWithReuseIdentifier: "ProductCell")
        collectionViewProduct.reloadData();
        
        let screenHeight = collectionViewCategory!.frame.size.height
        layout.itemSize = CGSize(width: 100, height: screenHeight)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal;
        
        collectionViewCategory!.collectionViewLayout = layout
        let nib1 = UINib(nibName: "ShopCategoryCell", bundle: nil)
        collectionViewCategory.register(nib1, forCellWithReuseIdentifier: "ShopCategoryCell")
        collectionViewCategory.reloadData();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetAllChildCategoryByParentId();
       // GetProductsByCatId()
    }
    
    @IBAction func btnBack(sender:UIButton){
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func GetAllChildCategoryByParentId() {
        
            if KAPPDELEGATE.isNetworkAvailable(){
                DispatchQueue.main.async {
                    HUD.show(.progress)
                }
                ApiManager.sharedInstance.requestGETURL(Constant.getAllChildCategoryByParentIdURL+""+parentCategoryId, success: { [self](JSON) in
                   
                    let msg =  JSON.dictionary?["Message"]?.stringValue
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                        listCategory = try! JSONDecoder().decode([HomeParentCategoryModel].self, from: jsonData!)
                        collectionViewCategory.reloadData()
                        DispatchQueue.main.async {
                            HUD.flash(.progress)
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
    
    func GetProductsByCatId() {
        if KAPPDELEGATE.isNetworkAvailable(){
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
        ApiManager.sharedInstance.requestGETURL(Constant.GetProductsByCatIdURL+""+parentCategoryId, success: { [self](JSON) in
           
            let msg =  JSON.dictionary?["Message"]?.stringValue
            if((JSON.dictionary?["IsSuccess"]) != false){
                
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listProducts = try! JSONDecoder().decode([Product].self, from: jsonData!)
                collectionViewProduct.reloadData()
                DispatchQueue.main.async {
                    HUD.flash(.progress)
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

extension ProductListViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCategory {
            return listCategory.count;
        }
        return listProducts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewCategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCategoryCell", for: indexPath) as! ShopCategoryCell
            cell.SetData(homeCategory: listCategory[indexPath.row])
            return cell;
        }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            cell.SetData(product: listProducts[indexPath.row])
            return cell;
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewCategory {
            //show search view controller 
            return;
        }
        
        //Product collection goes to productDetail
        let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductDetailViewController") as ProductDetailViewController
        vc.product = listProducts[indexPath.row];
        Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
    }
}

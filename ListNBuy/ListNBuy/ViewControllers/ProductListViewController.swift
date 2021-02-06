//
//  ProductListViewController.swift
//  ListNBuy
//
//  Created by Team A on 03/02/21.
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
    
    var listProducts:[Products] = [Products]()
    var listCategory:[HomeParentCategoryModel] = [HomeParentCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgViewBanner.imageFromServerURL(urlString: strImgBanner);
        
        let screenHeight = collectionViewCategory!.frame.size.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: screenHeight)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal;
        collectionViewCategory!.collectionViewLayout = layout
        let nib1 = UINib(nibName: "ShopCategoryCell", bundle: nil)
        collectionViewCategory.register(nib1, forCellWithReuseIdentifier: "ShopCategoryCell")
        collectionViewCategory.reloadData();
        
        let screenWidth = collectionViewProduct!.frame.size.width
        let layoutP: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutP.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layoutP.itemSize = CGSize(width: screenWidth/2.0-10, height: 200)
        layoutP.minimumInteritemSpacing = 0
        layoutP.minimumLineSpacing = 0
        layoutP.scrollDirection = UICollectionView.ScrollDirection.vertical;
        collectionViewProduct!.collectionViewLayout = layoutP
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionViewProduct.register(nib, forCellWithReuseIdentifier: "ProductCell")
        collectionViewProduct.reloadData();
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetAllChildCategoryByParentId();
        GetProductsByCatId()
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
                listProducts = try! JSONDecoder().decode([Products].self, from: jsonData!)
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
            cell.SetProductsData(product: listProducts[indexPath.row])
        
            return cell;
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewCategory {
            let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductCollectionViewController") as ProductCollectionViewController
            
            let category:HomeParentCategoryModel = listCategory[indexPath.row];
            vc.parentCategoryId = category.id
            Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
            return;
        }
        
        //Product collection goes to productDetail
        let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductDetailViewController") as ProductDetailViewController
        vc.product = Constant.getProductModelFromProductSModel(prod: listProducts[indexPath.row])
        Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
    }
}

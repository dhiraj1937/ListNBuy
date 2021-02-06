//
//  ProductCollectionViewController.swift
//  ListNBuy
//
//  Created by Team A on 04/02/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD

class ProductCollectionViewController: UIViewController {
   
    @IBOutlet var collectionView:UICollectionView!
    public var parentCategoryId:String!
    var listProducts:[Products] = [Products]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: screenWidth/2.0-10, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        collectionView.reloadData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GetProductsByCatId()
    }
    
    @IBAction func btnBack(sender:UIButton){
        self.navigationController?.popViewController(animated: true);
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
                collectionView.reloadData()
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

// MARK: UICollectionViewDataSource

extension ProductCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listProducts.count;
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        // Configure the cell
        cell.SetProductsData(product: listProducts[indexPath.row])
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductDetailViewController") as ProductDetailViewController
        vc.product = Constant.getProductModelFromProductSModel(prod: listProducts[indexPath.row])
        Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
    }

}

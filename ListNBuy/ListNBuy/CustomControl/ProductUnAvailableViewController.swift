//
//  ProductUnAvailableViewController.swift
//  ListNBuy
//
//  Created by Team A on 15/02/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

protocol ProductUnAvailableDelegate{
    func btnGoBackSelected()
}

class ProductUnAvailableViewController: UIViewController {
    
    @IBOutlet var btnGoBack:UIButton!
    @IBOutlet var btnCancel:UIButton!
    @IBOutlet var containerView:UIView!
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var cnstContainerViewHeight: NSLayoutConstraint!

    public var listProducts:[CartDetail] = [CartDetail]()
    
    var navigation:UINavigationController!
    var delegate:ProductUnAvailableDelegate!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    @IBAction func btnGoback_Click(){
        self.dismiss(animated: true, completion: nil)
        self.delegate.btnGoBackSelected()
    }
    
    @IBAction func btnCancel_Click(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TrendingCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TrendingCollectionCell")
        
        if listProducts.count < 3{
            cnstContainerViewHeight.constant = 350
        }else{
            cnstContainerViewHeight.constant = self.view.frame.size.height-250
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenWidth = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth/2.0, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        collectionView.reloadData();
    }

}

extension ProductUnAvailableViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listProducts.count;
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionCell", for: indexPath) as! TrendingCollectionCell
        let product = listProducts[indexPath.row]
        cell.img.imageFromServerURL(urlString: product.image)
        cell.lblTitle.text = product.name;
        return cell
    }
    
}

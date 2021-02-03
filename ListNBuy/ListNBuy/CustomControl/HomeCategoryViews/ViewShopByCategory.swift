//
//  ViewShopByCategory.swift
//  ListNBuy
//
//  Created by Apple on 19/01/21.
//

import UIKit

class ViewShopByCategory: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listHomeCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCategoryCell", for: indexPath) as! ShopCategoryCell
        cell.SetData(homeCategory: listHomeCategory[indexPath.row])
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeCategory:HomeParentCategoryModel = listHomeCategory[indexPath.row]
        let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductListViewController") as ProductListViewController
        vc.parentCategoryId = homeCategory.id
        vc.strImgBanner = homeCategory.image
        Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
    }
    
     private var listHomeCategory:[HomeParentCategoryModel] = [HomeParentCategoryModel]()
     @IBOutlet private var collectionView:UICollectionView!
     @IBOutlet private var contentView:UIView!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("ViewShopByCategory", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
           
            
        }
    
    public func RefreshData(_listHomeCategory:[HomeParentCategoryModel]){
        
        let screenWidth = collectionView!.frame.size.height
        let screenheight = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 100, height: screenWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal;
        
        collectionView!.collectionViewLayout = layout
        listHomeCategory = _listHomeCategory;
        let nib = UINib(nibName: "ShopCategoryCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ShopCategoryCell")
        collectionView.reloadData();
    }
    
}

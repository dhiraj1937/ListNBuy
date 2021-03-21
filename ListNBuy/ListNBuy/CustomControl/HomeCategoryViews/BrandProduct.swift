//
//  BrandProduct.swift
//  ListNBuy
//
//  Created by Apple on 23/01/21.
//

import UIKit

class BrandProduct: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listHomeCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCollectionCell", for: indexPath) as! BrandCollectionCell
        cell.SetData(homeCategory: listHomeCategory[indexPath.row])
        return cell;
    }
    
     private var listHomeCategory:[BrandModel] = [BrandModel]()
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
            Bundle.main.loadNibNamed("BrandProduct", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
           
            
        }
    
    public func RefreshData(_listHomeCategory:[BrandModel],wd:CGFloat){
        
        let screenWidth = collectionView!.frame.size.height
        let screenheight = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
       // layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        collectionView!.collectionViewLayout = layout
        listHomeCategory = _listHomeCategory;
        let nib = UINib(nibName: "BrandCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "BrandCollectionCell")
        collectionView.reloadData();
    }
}

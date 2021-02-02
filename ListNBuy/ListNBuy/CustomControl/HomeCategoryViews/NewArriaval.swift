//
//  NewArriaval.swift
//  ListNBuy
//
//  Created by Apple on 23/01/21.
//

import UIKit

class NewArriaval: UIView ,UICollectionViewDelegate,UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listProduct.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.SetData(product: listProduct[indexPath.row])
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductDetailViewController") as ProductDetailViewController
        vc.productId = listProduct[indexPath.row].id
        Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet private var collectionView:UICollectionView!
    @IBOutlet private var contentView:UIView!
    private var listProduct:[NewArrivalModel] = [NewArrivalModel]()
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("NewArriaval", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
           
        }
    
    public func RefreshData(_listProduct:[NewArrivalModel]){
        
        let screenWidth = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal;
        collectionView!.collectionViewLayout = layout
        listProduct = _listProduct;
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        collectionView.reloadData();
    }

}

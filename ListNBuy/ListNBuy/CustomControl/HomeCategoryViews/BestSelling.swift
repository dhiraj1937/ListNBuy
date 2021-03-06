//
//  BestSelling.swift
//  ListNBuy
//
//  Created by Apple on 23/01/21.
//

import UIKit

class BestSelling: UIView,UICollectionViewDelegate,UICollectionViewDataSource  {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listProduct.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.SetData(product: listProduct[indexPath.row])
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductDetailViewController") as ProductDetailViewController
            vc.product = listProduct[indexPath.row];
            vc.productId = listProduct[indexPath.row].id
            Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
            let vc = KHOMESTORYBOARD.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.product = listProduct[indexPath.row];
            vc.productId = listProduct[indexPath.row].id
            Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBOutlet private var collectionView:UICollectionView!
    private var listProduct:[Product] = [Product]()
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
            Bundle.main.loadNibNamed("BestSelling", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        }
    
    public func RefreshData(_listProduct:[Product],wd:CGFloat){
        collectionView!.frame.size.width = wd;
        
        let screenWidth = wd;//collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: screenWidth/2.0, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        listProduct = _listProduct;
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        collectionView.reloadData();
    }

}

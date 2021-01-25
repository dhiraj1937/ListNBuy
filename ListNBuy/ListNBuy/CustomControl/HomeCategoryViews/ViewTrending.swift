//
//  ViewTrending.swift
//  ListNBuy
//
//  Created by Apple on 21/01/21.
//

import UIKit

class ViewTrending: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTrending.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionCell", for: indexPath) as! TrendingCollectionCell
        cell.SetData(tredningProduct: listTrending[indexPath.row])
        return cell;
    }
    
    private var listTrending:[TredningProduct] = [TredningProduct]()
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
            Bundle.main.loadNibNamed("ViewTrending", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
           
        }

    
    public func RefreshData(_listTrending:[TredningProduct]){
        
        let screenWidth = collectionView!.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3.0, height: screenWidth/3.0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0;
        collectionView!.collectionViewLayout = layout
        
        listTrending = _listTrending;
        let nib = UINib(nibName: "TrendingCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TrendingCollectionCell")
        collectionView.reloadData();
    }
    
}
//
//  ViewBannerScrollView.swift
//  ListNBuy
//
//  Created by Apple on 20/01/21.
//

import Foundation
import UIKit
class ViewBannerScrollView : UIView,UIScrollViewDelegate
{
    @IBOutlet var contentView:UIView!
    @IBOutlet var sv:UIScrollView!
    @IBOutlet var pageController:UIPageControl!
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("ViewBannerScrollView", owner: self, options: nil)
            addSubview(contentView)
            contentView.frame = self.bounds;
            contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            sv.delegate = self
            sv.isPagingEnabled = true
            pageController.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        }
    
    @objc func changePage(sender: AnyObject) -> () {
            let x = CGFloat(pageController.currentPage) * sv.frame.size.width
            sv.setContentOffset(CGPoint(x:x, y:0), animated: true)
        }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageController.currentPage = Int(pageNumber)
        }
    
}

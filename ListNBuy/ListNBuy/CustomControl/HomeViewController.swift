//
//  HomeViewController.swift
//  ListNBuy
//
//  Created by Apple on 18/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class HomeViewController: UIViewController {

    @IBOutlet var txtSearch:UITextField!
    @IBOutlet var viewBanner:UIView!
    @IBOutlet var sv:UIScrollView!
    var listBanner:[Banner] = [Banner]()
    var listHomeBanner:[HomeBanner] = [HomeBanner]()
    var listHomeCategory:[HomeProductCategory] = [HomeProductCategory]()
    override func viewDidLoad() {
        super.viewDidLoad()
        GetHomeBannerData();
    }
    
    @IBAction func btnWhatsAppAvailabitliy(){
        let vc = WhatsAppOrderViewController.init(nibName: "WhatsAppOrderViewController", bundle: nil)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func GetBannerData(){
        if KAPPDELEGATE.isNetworkAvailable(){
           DispatchQueue.main.async {
                HUD.show(.progress)
           }
           ApiManager.sharedInstance.requestGETURL(Constant.getBannerURL, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listBanner = try! JSONDecoder().decode([Banner].self, from: jsonData!)
                let viewBanner = ViewBannerScrollView.init(frame: CGRect.init(x: 0, y: 210, width: Int(sv.frame.size.width), height: 200))
                var x:Int = 0;
                viewBanner.sv.contentSize = CGSize(width:viewBanner.sv.frame.size.width * CGFloat(listBanner.count),height: viewBanner.sv.frame.size.height)
                viewBanner.layer.cornerRadius = 10;
                viewBanner.clipsToBounds = true;
                for banner in listBanner
                {
                    let imgView:UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: 0, width: Int(sv.frame.size.width), height: 200))
                    imgView.imageFromServerURL(urlString: banner.BannerImg)
                    viewBanner.sv.addSubview(imgView)
                    x=x+Int(sv.frame.size.width);
                }
                viewBanner.pageController.numberOfPages = listBanner.count;
                sv.addSubview(viewBanner)
                
                let viewSection = ViewSection.init(frame: CGRect.init(x: 0, y: 420, width: Int(sv.frame.size.width), height: 50))
                viewSection.lblTitle.text = "Shop By Category";
                sv.addSubview(viewSection)
                
               }
               else{
               
               }
            GetHomeCategoryData();
           }, failure: { [self] (Error) in
            DispatchQueue.main.async {
                //HUD.flash(.error)
            }
           
            GetHomeCategoryData()
        })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    
    func GetHomeBannerData(){
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.getHomeBannerURL, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listHomeBanner = try! JSONDecoder().decode([HomeBanner].self, from: jsonData!)
                if(listHomeBanner.count>0){
                    let banner = listHomeBanner[0];
                    let viewBanner = ViewBanner.init(frame: CGRect.init(x: 0, y: 0, width: Int(sv.frame.size.width), height: 200))
                    viewBanner.imgBanner.imageFromServerURL(urlString: banner.BannerImg)
                    sv.addSubview(viewBanner)
                }
                HUD.flash(.progress)
               }
               else{
                HUD.flash(.progress)
               }
                GetBannerData()
           }, failure: { [self] (Error) in
                GetBannerData()
           })
           
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    
    func GetHomeCategoryData(){
        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
           ApiManager.sharedInstance.requestGETURL(Constant.getHomeParentCategoryWithProductURL, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listHomeCategory = try! JSONDecoder().decode([HomeProductCategory].self, from: jsonData!)
                let viewBanner = ViewShopByCategory.init(frame: CGRect.init(x: 0, y: 470, width: Int(sv.frame.size.width), height: 100))
                sv.addSubview(viewBanner)
                viewBanner.RefreshData(_listHomeCategory: listHomeCategory);
                HUD.flash(.progress)
               }
               else{
                HUD.flash(.progress)
               }
           
           }, failure: { [self] (Error) in
//            DispatchQueue.main.async {
//                HUD.flash(.error)
//            }
//            LPSnackbar.showSnack(title: AlertMsg.APIFailed)
           })
          
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    

}



//
//  HomeViewController.swift
//  ListNBuy
//  Created by Apple on 18/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class HomeViewController: UIViewController {
    
    @IBOutlet var tblSearch:UITableView!
    @IBOutlet var txtSearch:UITextField!
    @IBOutlet var viewBanner:UIView!
    @IBOutlet var searchView:UIView!
    @IBOutlet var sv:UIScrollView!
    @IBOutlet var btnWP:UIButton!
    @IBOutlet var cnstButtomBtnWP:NSLayoutConstraint!
    
    var listBanner:[Banner] = [Banner]()
    var listHomeBanner:[HomeBanner] = [HomeBanner]()
    var listSearch:[SearchModel] = [SearchModel]()
    var listTempSearch:[SearchModel] = [SearchModel]()
    var listHomeCategory:[HomeParentCategoryModel] = [HomeParentCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cnstButtomBtnWP.constant = 20
        GetSearchData();
        GetHomeBannerData();
        tblSearch.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        Constant.homeVC = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchFilter), name:  Notification.Name(rawValue: "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchProdcut), name:  Notification.Name(rawValue: "ClickSearch"), object: nil)
        let userID = UserDefaults.standard.getUserID()
        if(userID != ""){
            AddressController.getWalletCash(userid: userID) { (response) in
                self.AddWalletButton(vc: self, amount: Constant.walletCash)
            }
                AddressController.getPlanData { (response) in
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Helper.getCartListAPI { (res) in
            if(res){
                self.cnstButtomBtnWP.constant = 50
                self.AddCartView(view: self.view)
            }else{
                self.cnstButtomBtnWP.constant = 20
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        RemoveCart(view: self.view)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func btnWhatsAppAvailabitliy(){
        let vc = WhatsAppOrderViewController.init(nibName: "WhatsAppOrderViewController", bundle: nil)
        self.navigationController?.present(vc, animated: true, completion: nil)

    }
    
    @objc func SearchFilter(_ notification: Notification) {
      if let target = notification.userInfo?["item"] as? String {
        SearchProduct(str: target)
      }
    }
    
    
    
    @objc func SearchProdcut(){
        if(txtSearch.text!.count>0){
            if #available(iOS 13.0, *) {
                let vcSearch = KHOMESTORYBOARD.instantiateViewController(identifier: "SearchListViewController") as SearchListViewController
                vcSearch.searchText = txtSearch.text;
                self.navigationController?.pushViewController(vcSearch, animated: true);
            } else {
                // Fallback on earlier versions
                let vcSearch = KHOMESTORYBOARD.instantiateViewController(withIdentifier: "SearchListViewController") as! SearchListViewController
                vcSearch.searchText = txtSearch.text;
                self.navigationController?.pushViewController(vcSearch, animated: true);
            }
        
        }
    }
    
    func GetBannerData(){
        if KAPPDELEGATE.isNetworkAvailable(){
//           DispatchQueue.main.async {
//                HUD.show(.progress)
//           }
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
                    let activityIndi = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
                    activityIndi.startAnimating()
                    
                    viewBanner.sv.addSubview(activityIndi)
                    let imgView:UIImageView = UIImageView.init(frame: CGRect.init(x: x, y: 0, width: Int(sv.frame.size.width), height: 200))
                    activityIndi.frame = CGRect.init(x: (Int(imgView.frame.size.width)/2+x)-15, y: 100, width: 30, height: 30)
                    imgView.imageFromServerURL(urlString: banner.BannerImg)
                    imgView.backgroundColor = UIColor.clear;
                    viewBanner.sv.addSubview(imgView)
                    //R0123
                    let btnDetail = UIButton.init(frame: imgView.frame)
                    btnDetail.backgroundColor = .clear
                    btnDetail.tag = Int(banner.Id)!
                    btnDetail.addTarget(self, action:#selector(btnBannerpressed(sender:)), for: .touchUpInside)
                    viewBanner.sv.addSubview(btnDetail)
                    x=x+Int(sv.frame.size.width);
                }
                viewBanner.pageController.numberOfPages = listBanner.count;
                sv.addSubview(viewBanner)
                let viewSection = ViewSection.init(frame: CGRect.init(x: 0, y: 420, width: Int(sv.frame.size.width), height: 50))
                viewSection.lblTitle.text = "Shop By Category";
                sv.addSubview(viewSection)
               }else{}
            GetHomeCategoryData();
           }, failure: { [self] (Error) in
            GetHomeCategoryData()
        })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            HUD.flash(.progress)
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
                    viewBanner.btnBanner.tag = Int(banner.Id)!
                    viewBanner.btnBanner.addTarget(self, action:#selector(btnBannerpressed(sender:)), for: .touchUpInside)//R1

                    sv.addSubview(viewBanner)
                }
                //HUD.flash(.progress)
               }
               else{
                //HUD.flash(.progress)
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
    
    @objc func btnBannerpressed(sender: UIButton!) {
        print("btnBannerpressed=\(sender.tag)")
        if #available(iOS 13.0, *) {
            let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "ProductCollectionViewController") as ProductCollectionViewController
            vc.parentCategoryId = String(sender.tag)
            Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
            let vc = KHOMESTORYBOARD.instantiateViewController(withIdentifier: "ProductCollectionViewController") as! ProductCollectionViewController
            vc.parentCategoryId = String(sender.tag)
            Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
        }
       
    }

    func GetHomeCategoryData(){
        if KAPPDELEGATE.isNetworkAvailable(){
//            DispatchQueue.main.async {
//                HUD.show(.progress)
//            }
           ApiManager.sharedInstance.requestGETURL(Constant.getHomeParentCategoryURL, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                listHomeCategory = try! JSONDecoder().decode([HomeParentCategoryModel].self, from: jsonData!)
                let viewBanner = ViewShopByCategory.init(frame: CGRect.init(x: 0, y: 470, width: Int(sv.frame.size.width), height: 100))
                sv.addSubview(viewBanner)
                viewBanner.RefreshData(_listHomeCategory: listHomeCategory, wd: sv.frame.size.width);
               }
               else{}
           }, failure: { [self] (Error) in

           })
            let viewSection = ViewSection.init(frame: CGRect.init(x: 0, y: 570, width: Int(sv.frame.size.width), height: 50))
            viewSection.lblTitle.text = "Trending Product";
            sv.addSubview(viewSection)
            GetTrendingData();
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            HUD.flash(.progress)
        }
    }
    
    func GetTrendingData(){
        if KAPPDELEGATE.isNetworkAvailable(){
//            DispatchQueue.main.async {
//                HUD.show(.progress)
//            }
           ApiManager.sharedInstance.requestGETURL(Constant.getRandomProductURL, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                let listtrending = try! JSONDecoder().decode([TredningProduct].self, from: jsonData!)
                let viewBanner = ViewTrending.init(frame: CGRect.init(x: 0, y: 630, width: Int(sv.frame.size.width), height: 250))
                sv.addSubview(viewBanner)
                viewBanner.RefreshData(_listTrending: listtrending, wd: sv.frame.size.width)
                
               }else{}
           
           }, failure: { [self] (Error) in

           })
           // sv.contentSize = CGSize.init(width: 0, height: 970)
            GetHomeCategoryWithProductData();
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            HUD.flash(.progress)
        }
    }
    
    func GetHomeCategoryWithProductData(){
        if KAPPDELEGATE.isNetworkAvailable(){
        var yXs:Int = 880;
           ApiManager.sharedInstance.requestGETURL(Constant.getHomeParentCategoryWithProductURL+"/"+UserDefaults.standard.getUserID(), success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                
                let listHomeCategory = try! JSONDecoder().decode([HomeCategoryProduct].self, from: jsonData!)
                
                for homecat in listHomeCategory {
                    //Add Section
                    let viewSection = ViewSection.init(frame: CGRect.init(x: 0, y: yXs, width: Int(sv.frame.size.width), height: 50))
                    viewSection.lblTitle.text = homecat.title;
                    sv.addSubview(viewSection)
                    yXs=yXs+50;
                    print("width=\(sv.frame.size.width)");
                    //Add Products
                    let viewProduct = ProductCategoryView.init(frame: CGRect.init(x: 0, y: yXs, width: Int(sv.frame.size.width), height: 400))
                    viewProduct.RefreshData(_listProduct: homecat.product, wd: CGFloat(sv.frame.size.width))
                    sv.addSubview(viewProduct)
                    yXs=yXs+410;
                    
                    //Add Banner
                    let viewBanner = ViewBanner.init(frame: CGRect.init(x: 0, y: yXs, width: Int(sv.frame.size.width), height: 200))
                    viewBanner.imgBanner.imageFromServerURL(urlString: homecat.image)
                    viewBanner.btnBanner.tag = Int(homecat.id)!
                    viewBanner.btnBanner.addTarget(self, action:#selector(btnBannerpressed(sender:)), for: .touchUpInside)//R2
                    yXs=yXs+200;
                    sv.addSubview(viewBanner)
                }
                let viewSection = ViewSection.init(frame: CGRect.init(x: 0, y: yXs, width: Int(sv.frame.size.width), height: 50))
                viewSection.lblTitle.text = "Shop By Brand";
                sv.addSubview(viewSection)
                yXs=yXs+50;
               }
               else{}
            GetBrandProductData(yx: yXs)
           }, failure: { [self] (Error) in
            GetBrandProductData(yx: yXs)
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            HUD.flash(.progress)
        }
    }
    
    func GetNewArriavalData(yx:Int){
        if KAPPDELEGATE.isNetworkAvailable(){
           ApiManager.sharedInstance.requestGETURL(Constant.GetNewArrivalProductURL+"/"+UserDefaults.standard.getUserID(), success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                let listNewArriaval = try! JSONDecoder().decode([Product].self, from: jsonData!)
                let viewBanner = NewArriaval.init(frame: CGRect.init(x: 0, y: yx, width: Int(sv.frame.size.width), height: 200))
                sv.addSubview(viewBanner)
                viewBanner.RefreshData(_listProduct: listNewArriaval, wd: sv.frame.size.width)
                
                if(listHomeBanner.count>0){
                    let banner = listHomeBanner[listHomeBanner.count-1];
                    let viewBanner = ViewBanner.init(frame: CGRect.init(x: 0, y: yx+200, width: Int(sv.frame.size.width), height: 200))
                    viewBanner.imgBanner.imageFromServerURL(urlString: banner.BannerImg)
                    viewBanner.btnBanner.tag = Int(banner.Id)!
                    viewBanner.btnBanner.addTarget(self, action:#selector(btnBannerpressed(sender:)), for: .touchUpInside)//R3
                    sv.addSubview(viewBanner)
                }
                if(true){
                    let viewMember = MemberShipView.init(frame: CGRect.init(x: 0, y: yx+400, width: Int(sv.frame.size.width), height: 100))
                    sv.addSubview(viewMember)
                    let viewSubscription = Subscription.init(frame: CGRect.init(x: 0, y: yx+500, width: Int(sv.frame.size.width), height: 200))
                    sv.addSubview(viewSubscription)
                    sv.contentSize = CGSize.init(width: 0, height: yx+700)
                }
                else{
                    let viewSubscription = Subscription.init(frame: CGRect.init(x: 0, y: yx+400, width: Int(sv.frame.size.width), height: 200))
                    sv.addSubview(viewSubscription)
                    sv.contentSize = CGSize.init(width: 0, height: yx+600)
                }
                
               }else{}
            HUD.flash(.progress)
           }, failure: { [self] (Error) in
                HUD.flash(.progress)
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            HUD.flash(.progress)
        }
    }
    
    func GetMostProductData(yx:Int){
        if KAPPDELEGATE.isNetworkAvailable(){
        var yXs:Int = yx;
           ApiManager.sharedInstance.requestGETURL(Constant.GetMostProductURL+"/"+UserDefaults.standard.getUserID(), success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                
                let listHomeCategory = try! JSONDecoder().decode([Product].self, from: jsonData!)
                let viewProduct = BestSelling.init(frame: CGRect.init(x: 0, y: yXs, width: Int(sv.frame.size.width), height: 400))
                    viewProduct.RefreshData(_listProduct: listHomeCategory, wd: CGFloat(sv.frame.size.width))
                sv.addSubview(viewProduct)
                yXs=yXs+410;
                let viewSection = ViewSection.init(frame: CGRect.init(x: 0, y: yXs, width: Int(sv.frame.size.width), height: 50))
                viewSection.lblTitle.text = "New Arrival";
                sv.addSubview(viewSection)
                yXs=yXs+50;
               }
               else{}
            GetNewArriavalData(yx: yXs)
           }, failure: { [self] (Error) in
            GetNewArriavalData(yx: yXs)
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            HUD.flash(.progress)
        }
    }

    
    func GetBrandProductData(yx:Int){
        if KAPPDELEGATE.isNetworkAvailable(){
//            DispatchQueue.main.async {
//                HUD.show(.progress)
//            }
            var yXs:Int = yx;
           ApiManager.sharedInstance.requestGETURL(Constant.GetBrandProductURL, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                let listHomeCategory = try! JSONDecoder().decode([BrandModel].self, from: jsonData!)
                let viewBanner = BrandProduct.init(frame: CGRect.init(x: 0, y: yx, width: Int(sv.frame.size.width), height: 100))
                sv.addSubview(viewBanner)
                viewBanner.RefreshData(_listHomeCategory: listHomeCategory, wd: sv.frame.size.width);
                yXs=yXs+110;
                let viewSection = ViewSection.init(frame: CGRect.init(x: 0, y: yXs, width: Int(sv.frame.size.width), height: 50))
                viewSection.lblTitle.text = "Best Selling";
                sv.addSubview(viewSection)
                yXs=yXs+50;
                GetMostProductData(yx: yXs);
               }
               else{}
           }, failure: { [self] (Error) in
            GetMostProductData(yx: yXs);
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
            HUD.flash(.progress)
        }
    }
    
    
    func GetSearchData(){
        if KAPPDELEGATE.isNetworkAvailable(){
//            DispatchQueue.main.async {
//                HUD.show(.progress)
//            }
            ApiManager.sharedInstance.requestGETURL(Constant.GetAutoSearchProductListURL, success: { [self]
               (JSON) in
               if((JSON.dictionary?["IsSuccess"]) != false){
                    let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                    listSearch = try! JSONDecoder().decode([SearchModel].self, from: jsonData!)
                    //HUD.flash(.progress)
               }
               else{
                    //HUD.flash(.progress)
               }
               //GetBannerData()
           }, failure: { [self] (Error) in
               //GetBannerData()
           })
       }
        else{
            //LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
    
    func SearchProduct(str:String){
        print(str)
        listTempSearch.removeAll();
        if(listSearch.count>0){
            let list3 = listSearch.filter{ ($0.name.lowercased().contains(str.lowercased())) }
            listTempSearch.append(contentsOf: list3)
            tblSearch.reloadData();
        }
        if(listTempSearch.count>0){
            var height = listTempSearch.count*44;
            if(Int(sv.frame.size.height-100) < height){
                height = Int(sv.frame.size.height-100);
            }
            tblSearch.frame = CGRect.init(x: searchView.frame.origin.x, y: searchView.frame.origin.y+searchView.frame.size.height-10, width: searchView.frame.size.width, height: CGFloat(height))
            self.view.addSubview(tblSearch);
            self.tblSearch.isHidden = false;
        }
        else{
            self.tblSearch.removeFromSuperview();
            self.tblSearch.isHidden = true;
        }
    }
   
    
}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTempSearch.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        cell.textLabel?.text = listTempSearch[indexPath.row].name;
        cell.selectionStyle=UITableViewCell.SelectionStyle.none;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtSearch.text =  listTempSearch[indexPath.row].name;
        tblSearch.isHidden = true;
    }
   
}




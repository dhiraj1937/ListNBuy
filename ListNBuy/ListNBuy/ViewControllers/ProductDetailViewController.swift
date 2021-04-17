//
//  ProductDetailViewController.swift
//  ListNBuy
//
//  Created by Team A on 31/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class ProductDetailViewController: UIViewController, PinViewButtonDelegate {
    public var productId:String!
    public var product:Product!;
    var selectedMou: String?
    var selectedVariant: String?
    var selectedPicker:Int = 0
    var arrPicker:[String] = [String]()
    var arrMous:[String] = []
    var arrVariants:[String] = []
    
    @IBOutlet weak var btnShowCart:UIButton!
    @IBOutlet weak var imgProductImage:UIImageView!
    @IBOutlet weak var lblProductName:UILabel!
    @IBOutlet weak var lblRate:UILabel!
    @IBOutlet weak var lblActualRate:UILabel!
    @IBOutlet weak var btnAddToWishlist:UIButton!
    @IBOutlet weak var lblDesc:UILabel!
    @IBOutlet weak var btnAddToCart:UIButton!
    @IBOutlet weak var scrollview:UIScrollView!

    @IBOutlet weak var pickerView :UIPickerView!
    @IBOutlet weak var btnDropDownMou:UIButton!
    @IBOutlet weak var btnDropDownVariant:UIButton!
    @IBOutlet weak var viewPickerContainer:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        btnDropDownMou.setTitle("Select", for: .normal)
        btnDropDownVariant.setTitle("Select", for: .normal)
        btnDropDownVariant.titleLabel?.textColor = UIColor.black;
        btnDropDownMou.titleLabel?.textColor = UIColor.black;
        
        if self.view.frame.size.height < 500 {
            scrollview.contentSize = CGSize(width:self.scrollview.frame.size.width,height:688)
        }
        
        if productId != nil {
            getProductDetails()
        }else{
            setupInitialData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Helper.getCartListAPI { (res) in
            if(res){
                if(!Constant.IsTabPage){
                    self.AddCartViewInDetail(view: self.view)
                }
                else{
                    self.AddCartViewInTabDetail(view: self.view)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        RemoveCart(view: self.view)
    }
    
    func setupInitialData() {
        for objP in product.variation {
            arrMous.append(objP.attributeName)
            arrVariants.append(objP.attributeName1)
        }
        
        if(product.variation.count>0){
            btnDropDownMou.setTitle(product.variation[0].attributeName, for: UIControl.State.normal)
            btnDropDownVariant.setTitle(product.variation[0].attributeName1, for: UIControl.State.normal)
        }
        
        imgProductImage.imageFromServerURL(urlString: product.image);
        lblDesc.text = product.productDescription;
        lblProductName.text = product.name;
        if(product.variation.count>0){
          //  lblActualRate.attributedText = Helper.GetStrikeTextAttribute(txt: "RS."+product.variation[0].regularPrice.description);
            lblActualRate.attributedText = NSAttributedString(string: "RS."+product.variation[0].regularPrice.description, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.orange])
            //lblRate.text = "RS."+product.variation[0].memberPrice.description;
            let salPrice = Float(product.variation[0].salePrice.description)
            let memberPrice = Float(product.variation[0].memberPrice.description)
            
            lblRate.text = "RS."+(Constant.isShowingSalesPrice == true ? String(format: "%.2f", salPrice as! CVarArg): String(format: "%.2f", memberPrice as! CVarArg))
        }
        if(product.wishlist==0){
            btnAddToWishlist.isSelected = false
        }
        else{
            btnAddToWishlist.isSelected = true
        }
        self.changeAddToCartButton()
    }
    func changeAddToCartButton(){
        if(Constant.listCartProducts.count>0){
            let pro = Constant.listCartProducts.filter { $0.id==product.id }.first
            if(pro != nil){
                btnAddToCart.backgroundColor = UIColor.init(hexString: "#008F00");
                btnAddToCart.isUserInteractionEnabled = false;
            }
            else{
                btnAddToCart.backgroundColor = UIColor.init(hexString: "#8849A0");
                btnAddToCart.isUserInteractionEnabled = true;
            }
        }
        else{
            btnAddToCart.backgroundColor = UIColor.init(hexString: "#8849A0");
            btnAddToCart.isUserInteractionEnabled = true;
        }
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDropDownMouAction(){
        scrollview.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        showPickerView(pickerFor:"MOU")
    }
    @IBAction func btnDropDownVariantAction(){
        scrollview.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        showPickerView(pickerFor:"VARIANT")
    }
    @IBAction func btnDoneForDismissPicker(){
        scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        dismissPickerView()
    }
    @IBAction func btnAddToCartAction(){
        
        let userID = UserDefaults.standard.getUserID()
        if userID == "" {
            (KAPPDELEGATE.window!.rootViewController as! UINavigationController?)!.popToRootViewController(animated: true)
            return
        }
        
        let userPin = UserDefaults.standard.getUserPin()
        if userPin == "" {
            //show popup
            let vc = PinViewController.init(nibName: "PinViewController", bundle: nil)
            vc.delegate = self
            self.navigationController?.present(vc, animated: true, completion: nil)
        }else{
            
            let userID = UserDefaults.standard.getUserID()
            var dic = [String:AnyObject]()
            dic["userId"] = userID as AnyObject
            dic["productId"] = product.id as AnyObject
            dic["variationId"] = product.variation[0].varID as AnyObject
            dic["quantity"] = "1" as AnyObject
            dic["PIN"] = userPin as AnyObject
            
            WishListController.addCartAPI(vc: self, dicObj: dic) { (response) in
                print(response)
                if(response == "Success"){
                    self.RemoveCart(view: self.view)
                    Helper.getCartListAPI { (res) in
                        if(res){
                            if(!Constant.IsTabPage){
                                self.AddCartViewInDetail(view: self.view)
                            }
                            else{
                                self.AddCartViewInTabDetail(view: self.view)
                            }
                            self.changeAddToCartButton()
                        }
                    }
                }
            }
        }
    }
    
    func submitPin(pin:String,responseReturn:@escaping (String) -> Void){
        let userID = UserDefaults.standard.getUserID()
        var dic = [String:AnyObject]()
        dic["userId"] = userID as AnyObject
        dic["productId"] = product.id as AnyObject
        dic["variationId"] = product.variation[0].varID as AnyObject
        dic["quantity"] = "1" as AnyObject
        dic["PIN"] = pin as AnyObject
        
        WishListController.addCartAPI(vc: self, dicObj: dic) { (response) in
            print(response)
            if(response == "Success"){
                self.RemoveCart(view: self.view)
                Helper.getCartListAPI { (res) in
                    if(res){
                        self.AddCartView(view: self.view)
                        self.changeAddToCartButton()
                    }
                }
                responseReturn("PASS");
            }else{
                responseReturn("FAIL");
            }
        }
        
    }
    
    @IBAction func btnShowCartAction(){
        
        let userID = UserDefaults.standard.getUserID()
        if userID == "" {
            (KAPPDELEGATE.window!.rootViewController as! UINavigationController?)!.popToRootViewController(animated: true)
            return
        }
        
        if #available(iOS 13.0, *) {
            let vc = KHOMESTORYBOARD.instantiateViewController(identifier: "CheckOutViewController") as CheckOutViewController
            Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
            let vc = KHOMESTORYBOARD.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
            Constant.GetCurrentVC().navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func btnAddToWishlistAction(){
        WishListController.addWishlistAPI(productID: product.id, vc: self) { [self] (response) in
            if response == "Success"{
                btnAddToWishlist.isSelected = true
            }
        }
    }

    
    func getProductDetails() {

        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let userID = UserDefaults.standard.getUserID()
            let strUrl = Constant.getProductDetailsURL+""+productId+"/"+userID
            print(strUrl as Any)
            ApiManager.sharedInstance.requestGETURL(strUrl, success: { [self]
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                print(msg as Any)
                if((JSON.dictionary?["IsSuccess"]) != false){
                    
                    let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                    let productD =  try! JSONDecoder().decode([ProductDetail].self, from: jsonData!)
                    print(productD)
                    product = Constant.getProductModelFromProductDetailModel(prod: productD[0])
                    self.setupInitialData()
                    HUD.flash(.progress)
                }
                DispatchQueue.main.async {
                    HUD.flash(.progress)
                }
            }, failure: { (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
            }
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
}
extension ProductDetailViewController:  UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedPicker == 1 {
            selectedMou = arrPicker[row] // selected item
            btnDropDownMou.setTitle(selectedMou, for: .normal)
        }else if selectedPicker == 2 {
            selectedVariant = arrPicker[row]
            btnDropDownVariant.setTitle(selectedVariant, for: .normal)
            if(product.variation.count>0){
               // lblActualRate.attributedText = Helper.GetStrikeTextAttribute(txt: "RS."+product.variation[row].regularPrice.description);
                lblActualRate.attributedText = NSAttributedString(string: "RS."+product.variation[row].regularPrice.description, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.orange])
                lblRate.text = "RS."+product.variation[row].memberPrice.description;
            }
        }
            
    }
    
    func showPickerView(pickerFor:String) {
        
        arrPicker.removeAll()
        if pickerFor == "MOU" {
            selectedPicker = 1
            arrPicker.append(contentsOf: arrMous)
        }else{
            selectedPicker = 2
            arrPicker.append(contentsOf: arrVariants)
        }
        viewPickerContainer.isHidden = false
        pickerView.reloadAllComponents()
        let cartView = self.view.viewWithTag(-200);
        if(cartView != nil){
            cartView?.isHidden = true;
        }
    }
    
    func dismissPickerView() {
        viewPickerContainer.isHidden = true
        let cartView = self.view.viewWithTag(-200);
        if(cartView != nil){
            cartView?.isHidden = false;
        }
    }
    
}

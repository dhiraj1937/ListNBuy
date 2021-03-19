//
//  Helper.swift
//  ListNBuy
//
//  Created by Team A on 09/01/21.
//

import Foundation
import UIKit
import CoreLocation
import PKHUD
import LPSnackbar

class Helper: NSObject {
    public static func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String,txt:UITextView) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    txt.text = addressString
                    print(addressString)
                }
        })
    }
    
    static func GetStrikeTextAttribute(txt:String) -> NSAttributedString{
        let attrString = NSAttributedString(string: txt, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        return attrString
    }
    
    static func getCartListAPI(response:@escaping (Bool) -> Void) {

        if KAPPDELEGATE.isNetworkAvailable(){
            let userID = UserDefaults.standard.getUserID()
            let strUrl = Constant.getCartListURL+""+userID
            print(strUrl as Any)
            Constant.listCartProducts.removeAll();
            ApiManager.sharedInstance.requestGETURL(strUrl, success: { [self]
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                print(msg as Any)
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                    Constant.listCartProducts =  try! JSONDecoder().decode([CartDetail].self, from: jsonData!)
                    Constant.totalAmount = 0;
                    
                    var mrp = 0.0
                    var quantity = 0;
                    for item in Constant.listCartProducts {
                        //same as android
                        //mrp = mrp + Double(item.quantity)! * (Constant.isShowingSalesPrice == true ? Double(item.salePrice) : Double(item.memberPrice))
                        mrp = mrp + Double(item.quantity)! * Double(item.salePrice)
                        quantity = quantity+Int(item.quantity)!;
                    }
                    
                    //same as android
                    //Constant.totalAmount = Double(String(format: "%.2f", mrp))!
                    Constant.totalAmount = Double(String(format: "%.0f", mrp))!
                    Constant.totalItemCount = quantity;
                    response(true)
                }
                else{
                    response(false)
                }
            }, failure: { (Error) in
                response(false)
           })
       }
        else{
           
        }
    }
    
    static func CheckAvailableProdcutAPI(pincode:String,response:@escaping ([NotAvailableProduct]) -> Void) {

        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            let userID = UserDefaults.standard.getUserID()
            let params :[String:Any] = ["Pincode":pincode,"UserId":userID]
            ApiManager.sharedInstance.requestPOSTURL(Constant.ApplyPinCodeURL, params: params, success: {(JSON) in
                let msg =  JSON.dictionary?["Message"]
                print(msg as Any)
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let jsonData =  JSON.dictionary?["ResponseData"]!.rawString()!.data(using: .utf8)
                    let list =  try! JSONDecoder().decode([NotAvailableProduct].self, from: jsonData!)
                    response(list)
                }
                else{
                    response([])
                }
                DispatchQueue.main.async {
                    HUD.flash(.progress)
                }
                
            }, failure: { (Error) in
                //response([])
                DispatchQueue.main.async {
                    HUD.flash(.progress)
                }
                LPSnackbar.showSnack(title: Error.localizedDescription)
                
           })
       }
        else{
           
        }
    }
    
}

class RoundedCornerView: UIView {
    
    // if cornerRadius variable is set/changed, change the corner radius of the UIView
    @IBInspectable override var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
}
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = UserDefaults.standard.getUserID()
        if(userID != ""){
            self.AddWalletButton(vc: self, amount: Constant.walletCash)
        }
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

@IBDesignable extension UITextField {
    @IBInspectable var leftSpace:CGFloat {
        set {
            leftViewMode = ViewMode.always
            leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: newValue, height: frame.size.height))
        }
        get{
            return 20
            
        }
    }
    
    
    
    @IBInspectable var leftImage:UIImage {
        set {
            leftViewMode = ViewMode.always
            let imgView = UIImageView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            imgView.image = newValue
            view.addSubview(imgView)
            leftView = view
        }
        get{
            return UIImage.init()
            
        }
    }
    
    @IBInspectable var RightImage:UIImage {
        set {
            rightViewMode = ViewMode.always
            let imgView = UIImageView.init(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 45, height: 30))
            imgView.image = newValue
            view.addSubview(imgView)
            rightView = view
        }
        get{
            return UIImage.init()
            
        }
    }
    
}



extension UIViewController:UITextFieldDelegate,UITextViewDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClickSearch"), object: nil, userInfo: nil)
        return true;
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false;
        }
        else{
            return true;
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string=="" && textField.text?.count==1){
            let userInfo = ["item": ""]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "search"), object: nil, userInfo: userInfo)
        }
        else{
            let userInfo = ["item": textField.text]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "search"), object: nil, userInfo: userInfo)
        }
        return true;
    }
    
    func ArchivedUserDefaultObject(obj:Any,key:String){
        do{
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: true)
            UserDefaults.standard.set(encodedData, forKey: key)
            UserDefaults.standard.synchronize()
            print("Archived");
        }catch (let error){
            #if DEBUG
                print("Failed to convert obj to Data : \(error.localizedDescription)")
            #endif
        }
    }

    func UnArchivedUserDefaultObject(key:String) -> Any? {
        do{
            if let decodedData = UserDefaults.standard.object(forKey: key) as? Data{
                if key == "LoginUserData" {
                    if let decodedObj = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [LoginUserData.self], from: decodedData){
                        print("UnArchived = %@",decodedObj);
                        return decodedObj
                    }
                }else{
                    #if DEBUG
                        print("Add code UnArchived for key : \(key)")
                    #endif
                }
            }
        }catch (let error){
            #if DEBUG
                print("Failed to convert obj to Data : \(error.localizedDescription)")
            #endif
        }
        return nil
    }
    
    func AddWalletButton(vc:UIViewController,amount:String){
        var v = vc.view.viewWithTag(-1000)
        if(v != nil)
        {
            v?.removeFromSuperview();
            v=nil;
        }
        var fm = CGRect.init(x: (KAPPDELEGATE.window?.frame.size.width)!-100, y: 20, width: 100, height: 48)
        if vc.view.frame.height > 600{
            fm =  CGRect.init(x: (KAPPDELEGATE.window?.frame.size.width)!-100, y: 50, width: 100, height: 48)
        }
       // let mainView:UIView = UIView.init(frame: CGRect.init(x: (KAPPDELEGATE.window?.frame.size.width)!-100, y: 50, width: 100, height: 48))
        let mainView:UIView = UIView.init(frame:fm)
        if #available(iOS 14.0, *) {
            let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom, primaryAction: nil)
            btn.setImage(UIImage.init(named: "Wallet"), for: UIControl.State.normal)
            //btn.setTitle(amount, for: UIControl.State.normal)
            btn.titleLabel?.textColor = UIColor.white;
            btn.backgroundColor = UIColor.clear
            btn.frame = CGRect.init(x: 30, y: 0, width: 60, height: 50)
            btn.addTarget(self, action: #selector(ShowWallet), for: UIControl.Event.touchUpInside)
            let lblAMT = UILabel.init(frame: CGRect.init(x: 60, y: 0, width: 30, height: 20))
            lblAMT.text = String((amount as NSString).intValue
                                    + (Constant.superCashWalletAmount as NSString).intValue);
            lblAMT.textColor = UIColor.white;
            lblAMT.font = UIFont.boldSystemFont(ofSize: 12)
            lblAMT.textAlignment = NSTextAlignment.center
            lblAMT.backgroundColor = UIColor.red;
            lblAMT.layer.cornerRadius=10;
            lblAMT.clipsToBounds = true;
            lblAMT.numberOfLines=0;
            lblAMT.adjustsFontSizeToFitWidth = true;
            mainView.addSubview(btn);
            mainView.addSubview(lblAMT);
            let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(ShowWallet))
            mainView.gestureRecognizers?.append(tapgesture)
            mainView.tag = -1000;
            self.view.addSubview(mainView)
        } else {
            // Fallback on earlier versions
            let btn:UIButton = UIButton(type: .custom)
            btn.setImage(UIImage.init(named: "Wallet"), for: UIControl.State.normal)
            //btn.setTitle(amount, for: UIControl.State.normal)
            btn.titleLabel?.textColor = UIColor.white;
            btn.backgroundColor = UIColor.clear
            btn.frame = CGRect.init(x: 30, y: 0, width: 60, height: 50)
            btn.addTarget(self, action: #selector(ShowWallet), for: UIControl.Event.touchUpInside)
            let lblAMT = UILabel.init(frame: CGRect.init(x: 60, y: 0, width: 30, height: 20))
            lblAMT.text = amount;
            lblAMT.textColor = UIColor.white;
            lblAMT.font = UIFont.boldSystemFont(ofSize: 12)
            lblAMT.textAlignment = NSTextAlignment.center
            lblAMT.backgroundColor = UIColor.red;
            lblAMT.layer.cornerRadius=10;
            lblAMT.clipsToBounds = true;
            lblAMT.numberOfLines=0;
            lblAMT.adjustsFontSizeToFitWidth = true;
            mainView.addSubview(btn);
            mainView.addSubview(lblAMT);
            let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(ShowWallet))
            mainView.gestureRecognizers?.append(tapgesture)
            mainView.tag = -1000;
            self.view.addSubview(mainView)
        }
        
    }

    @objc func ShowWallet(){
        if #available(iOS 13.0, *) {
            let vc = KMAINSTORYBOARD.instantiateViewController(identifier: "WalletViewController") as WalletViewController
            self.navigationController?.pushViewController(vc, animated: true);
        } else {
            // Fallback on earlier versions
            let vc = KMAINSTORYBOARD.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            self.navigationController?.pushViewController(vc, animated: true);
        }
       
    }
    
    func AddCartView(view:UIView) {
        if(Constant.totalItemCount>0){
            let buttonHeight: CGFloat = view.safeAreaInsets.bottom
            if(buttonHeight==49){
                let viewBanner = ViewCartBottomView.init(frame: CGRect.init(x: 0, y: Int(view.frame.size.height)-90, width: Int(view.frame.size.width), height: 40))
                viewBanner.tag = -200;
                view.addSubview(viewBanner);
                viewBanner.SetData()
            }
            else{
                let viewBanner = ViewCartBottomView.init(frame: CGRect.init(x: 0, y: Int(view.frame.size.height)-Int(122), width: Int(view.frame.size.width), height: 40))
                viewBanner.tag = -200;
                view.addSubview(viewBanner);
                viewBanner.SetData()
            }
        }
    }
    
    func RemoveCart(view:UIView) {
        let v = view.viewWithTag(-200)
        v?.removeFromSuperview()
    }
    
    @IBAction func openCloseMenu(){
        TabbarViewController.revealController?.rearViewRevealWidth = self.view.frame.size.width-60;
        TabbarViewController.revealController?.revealToggle(UIButton.init())
    }

}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil;
        let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        URLSession.shared.dataTask(with: NSURL(string: encodedURL!)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
      func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
      }
}


extension UIView {
    
    /// The width of the layer's border, inset from the layer bounds. The border is composited above the layer's content and sublayers and includes the effects of the `cornerRadius' property. Defaults to zero. Animatable.
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    /// The color of the layer's border. Defaults to opaque black. Colors created from tiled patterns are supported. Animatable.
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    /// The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat{
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
}



extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UINavigationController
{
    /// Given the kind of a (UIViewController subclass),
    /// removes any matching instances from self's
    /// viewControllers array.

    func removeAnyViewControllers(ofKind kind: AnyClass)
    {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }

    /// Given the kind of a (UIViewController subclass),
    /// returns true if self's viewControllers array contains at
    /// least one matching instance.
    
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}


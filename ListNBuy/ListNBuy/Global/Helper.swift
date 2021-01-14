//
//  Helper.swift
//  ListNBuy
//
//  Created by Team A on 09/01/21.
//

import Foundation
import UIKit

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


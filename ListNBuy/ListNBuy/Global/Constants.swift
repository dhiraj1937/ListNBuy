//
//  Constants.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import Foundation
import UIKit

//Constents
let KAPPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let KScreenwidth  = UIScreen.main.bounds.size.width
let KScreenheight = UIScreen.main.bounds.size.height
let YOUR_APP_STORE_ID = 284815942 //Change this one to your ID static


//All storyboard
let KMAINSTORYBOARD      = UIStoryboard(name: "Main", bundle: nil)
let KHOMESTORYBOARD      = UIStoryboard(name: "Home", bundle: nil)
let KMYORDERSSTORYBOARD  = UIStoryboard(name: "MyOrders", bundle: nil)
let KOFFERSSTORYBOARD    = UIStoryboard(name: "Offers", bundle: nil)
let KWISHLISTSTORYBOARD  = UIStoryboard(name: "Wishlist", bundle: nil)
let KMYACCOUNTSTORYBOARD = UIStoryboard(name: "MyAccount", bundle: nil)


public class Constant {
    
    public static var currLat: Double = 0.0
    public static var currLng: Double = 0.0

    public static var APIKey:String = "123456789123456789"
    private static var serverURL:String = "https://projects.seawindsolution.com/YOGDEV/360/Webservices"

    
    public static var sendRegistrationOTPUrl:String = Constant.serverURL+"/sendRegistrationOTP";
    public static var reSendRegistrationOTPUrl:String = Constant.serverURL+"/reSendRegistrationOTP";
    public static var verifyRegistrationOTPURL:String = Constant.serverURL+"/verifyRegistrationOTP";
    public static var registrationUrl:String = Constant.serverURL+"/UserRegistration";
   
    
    public static var sendLoginOTPUrl:String = Constant.serverURL+"/sendLoginOTP";
    public static var loginUrl:String = Constant.serverURL+"/userLogin";
    public static var slugUrl:String = Constant.serverURL+"/getPages";
    public static var socialSettingsUrl:String = Constant.serverURL+"/getSocialSettingsData";
    public static var faqUrl:String = Constant.serverURL+"/getFaqData";
    public static var membershipPlanUrl:String = Constant.serverURL+"/getMembershipPlan";
    public static var getWhatsAppAvailibilityURL:String = Constant.serverURL+"/getWhatsAppAvailibility";
    public static var userByUserIdURL:String = Constant.serverURL+"/getUserByUserId";
    public static var getWalletURL:String = Constant.serverURL+"/getWallet";
    public static var getWalletTransactionURL:String = Constant.serverURL+"/getWalletTransaction";
    
    public static var getWalletPromoCodeURL:String = Constant.serverURL+"/getWalletPromoCode";
    public static var addToWalletURL:String = Constant.serverURL+"/addToWallet";
    public static var applyWalletPromoCodeURL:String = Constant.serverURL+"/applyWalletPromoCode";//"UserId","CODE"
    
    public static var getBannerURL:String = Constant.serverURL+"/getBanner";
    public static var getHomeBannerURL:String = Constant.serverURL+"/getHomeBanner";
    public static var getHomeParentCategoryWithProductURL:String = Constant.serverURL+"/getHomeParentCategoryWithProduct";
    public static var getRandomProductURL:String = Constant.serverURL+"/GetRandomProduct";
    public static var getHomeParentCategoryURL:String = Constant.serverURL+"/getHomeParentCategory";
    public static var GetNewArrivalProductURL:String = Constant.serverURL+"/GetNewArrivalProduct";
    public static var GetMostProductURL:String = Constant.serverURL+"/GetMostProduct";
    public static var GetBrandProductURL:String = Constant.serverURL+"/getHomeBrand";
    
    public static var getAddressList:String = Constant.serverURL+"/getAllUserAddressByUserId/";
    public static var getAddreesByIDURL:String = Constant.serverURL+"/getAllUserAddressByUserId/";///{id}
    public static var getAddreesByIDForMapURL:String = Constant.serverURL+"/getAllUserAddressByUserIdForMap/";///{id}
    public static var searchAddressURL:String = Constant.serverURL+"/getMapArea";
    public static var addAddressURL:String = Constant.serverURL+"/addNewUserAddress";
    public static var deleteAddressById:String = Constant.serverURL+"/deleteUserAddress";
    public static var editAddressURL:String = Constant.serverURL+"/editUserAddress";
    
    //getUserMembershipPlan
    public static var addMembershipURL:String = Constant.serverURL+"/addMembership";
    public static var getUserMembershipPlan:String = Constant.serverURL+"/getUserMembershipPlan/";//id
    
    public static var sendNewsLatterURL:String = Constant.serverURL+"/sendNewsLatter";
    public static var GetAutoSearchProductListURL:String = Constant.serverURL+"/GetAutoSearchProductList";
    
    
    public static var  globalTabbar:UITabBarController?
    public static var  walletCash:String?
    public static var  homeVC:UIViewController?;

    

}


//MARK:- Navigation controller extension
extension UINavigationController {
    
    func backToViewController(vc: Any) -> Bool {
        // iterate to find the type of vc
        for element in viewControllers  {
            if type(of: element) == type(of: vc) {
                self.popToViewController(element, animated: true)
                return true
            }
        }
        return false
    }
    
    
    func getViewCtrlObjectOfType(vc: Any) -> Any?{
        // iterate to find the type of vc
        for element in viewControllers  {
            if type(of: element) == type(of: vc) {
                return element
            }
        }
        return nil
    }
    
}

//MARK:- String Extensions
extension String {
    // Email Validation
    func validateEmail() -> Bool {
        var stringWhithoutWhiteSpaces: String = self
        stringWhithoutWhiteSpaces = stringWhithoutWhiteSpaces.replacingOccurrences(of: " " , with: "")
        let expression = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let regex = try? NSRegularExpression(pattern: expression, options: .caseInsensitive)
        let numberOfMatches: Int? = regex?.numberOfMatches(in: stringWhithoutWhiteSpaces, options: [], range: NSRange(location: 0, length: (stringWhithoutWhiteSpaces.count )))
        if numberOfMatches == 0 {
            return false
        }
        return true
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isAlphanumericAllowSpaces: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil
    }
    
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[A-Z])(?=.*[@#$%^&+=!])(?=\\S+$).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    var isNumeric: Bool {
        return range(of: "^[0-9]*$", options: .regularExpression) == nil
    }
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    func date(strFormat:String) -> Date {
        
        if self.count > 0 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = strFormat
            
            return dateFormatter.date(from: self) ?? Date()
        }
        
        return Date()
    }
    
    //String Extension for web
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var removeHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options:
                                            .regularExpression, range: nil)
            .replacingOccurrences(of: "&[^;]+;", with:
                                    "", options:.regularExpression, range: nil)
            .replacingOccurrences(of: "\n\n", with: "\n", options:
                                    .regularExpression, range: nil)
            .replacingOccurrences(of: "\n\n\n", with: "\n", options:
                                    .regularExpression, range: nil)
            .replacingOccurrences(of: "\t\t", with: "\t", options:
                                    .regularExpression, range: nil)
            .replacingOccurrences(of: "\t\t\t", with: "\t", options:
                                    .regularExpression, range: nil)
            .replacingOccurrences(of: "   ", with: " ", options:
                                    .regularExpression, range: nil)
    }
    
    func attributedText(color:UIColor) -> NSAttributedString{
        
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func toData()-> Data? {
        return self.data(using: .utf8)
    }
}

@IBDesignable
class RJViewCornerRadius: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5;
        self.clipsToBounds = true
    }
    
}

@IBDesignable
class RJBorderedTF: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 21
        self.dropShadow(scale: true)
        // self.layer.borderWidth = 0.5
        // self.clipsToBounds = true
    }
    
    let padding = UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 40)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

@IBDesignable
class RJShadowView:UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dropShadow(scale: true)
        self.layer.cornerRadius = 15
    }
}

//MARK:UIView Extension
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
    }
}




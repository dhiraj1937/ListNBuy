//
//  UserModel.swift
//  ListNBuy
//
//  Created by Team A on 12/01/21.
//

import Foundation


public class LoginUserData:NSObject, Codable{
    var Id:String;
    var Name:String;
    var Email:String
    var Phone:String
    var SignBy:String
    var Role:String
    var Status:String
    var EntDt:String
    init(Id: String, Name: String,Email: String, Phone: String,SignBy:String,Role:String,Status:String,EntDt:String) {
        self.Id = Id
        self.Name = Name
        self.Email = Email
        self.Phone = Phone
        self.SignBy = SignBy
        self.Role = Role
        self.Status = Status
        self.EntDt = EntDt
    }
}

public class RegisterUserData:NSObject, Codable{
    var Id:String;
    var Name:String;
    var Email:String
    var Phone:String
    var SignBy:String
    var Role:String
    init(Id: String, Name: String,Email: String, Phone: String,SignBy:String,Role:String) {
        self.Id = Id
        self.Name = Name
        self.Email = Email
        self.Phone = Phone
        self.SignBy = SignBy
        self.Role = Role
    }
}

public class SocialSettingData:Codable{
    var Title:String;
    var Link:String
    var Icon:String
    init(Title: String, Link: String, Icon: String) {
        self.Title = Title
        self.Link = Link
        self.Icon = Icon
    }
}

public class ContactUsModel:Codable{
    var Address:String?
    var Phone:String?
    var Web:String?
    var Email:String?
    var latitude:String?
    var longitude:String?
    init(Address: String, Phone: String,Web: String, Email: String, latitude: String, longitude: String) {
        self.Address = Address
        self.Phone = Phone
        self.Web = Web
        self.Email = Email
        self.latitude = latitude
        self.longitude = longitude
    }
}

public class FAQModel:Codable{
    var Id:String?
    var Title:String?
    var Content:String?
    var EntDt:String?
    var IsShow:Bool = false
    var Direction:String = "ic_expand_more_black"
    var Answer:String = ""
    enum CodingKeys:String,CodingKey {
            case Id, Title,Content,EntDt
        }
    init(Id: String, Title: String, Content: String, EntDt: String) {
        self.Id = Id
        self.Title = Title
        self.Content = Content
        self.EntDt = EntDt
    }
}

    public class MembershipPlanData:NSObject, Codable{
    var Id:String;
    var Title:String;
    var SubTitle:String
    var Content:String
    var Price:String
    var Duration:String
    init(Id: String, Title: String,SubTitle: String, Content: String,Price:String,Duration:String) {
        self.Id = Id
        self.Title = Title
        self.SubTitle = SubTitle
        self.Content = Content
        self.Price = Price
        self.Duration = Duration
    }
}

public class WalletAmount: Codable{
    var Id:String;
    var Title:String;
    var Role:String
    var walletAmount:String
    var superCashWalletAmount:String
    var ExpiryDate:String
    init(Id: String, Title: String,Role: String, walletAmount: String,superCashWalletAmount:String,ExpiryDate:String) {
        self.Id = Id
        self.Title = Title
        self.Role = Role
        self.walletAmount = walletAmount
        self.superCashWalletAmount = superCashWalletAmount
        self.ExpiryDate = ExpiryDate
    }
}

/*
{
    "IsSuccess": true,
    "Message": "Wallet Get Successfully",
    "ResponseData": {
        "Id": "33",
        "Role": "0",
        "walletAmount": "40",
        "superCashWalletAmount": "0",
        "ExpiryDate": "",
        "Title": ""
    }
}
*/

public class WalletTransaction: Codable{
    var Id:String;
    var UserId:String;
    var Role:String
    var TrnType:String
    var Amount:String
    var RemainingAmount:String
    var SupperCashAmount:String
    var RemainingSuperCashAmount:String
    var CODE:String
    var TransactionId:String
    var Message:String
    var payMethod:String
    var payStatus:String
    var payDate:String
    //var `Type`:String
    var OrderId:String
    var Status:String

    init(Id: String, UserId: String,Role: String, TrnType: String,Amount:String,RemainingAmount:String,SupperCashAmount: String, RemainingSuperCashAmount: String, CODE: String,TransactionId:String,Message:String,payMethod: String, payStatus: String,payDate: String,OrderId:String,Status:String) {// `Type`: String
        self.Id = Id
        self.UserId = UserId
        self.Role = Role
        self.TrnType = TrnType
        self.Amount = Amount
        self.RemainingAmount = RemainingAmount
        self.SupperCashAmount = SupperCashAmount
        self.RemainingSuperCashAmount = RemainingSuperCashAmount
        self.CODE = CODE
        self.TransactionId = TransactionId
        self.Message = Message
        self.payMethod = payMethod
        self.payStatus = payStatus
        self.payDate = payDate
        //self.`Type` = `Type`
        self.OrderId = OrderId
        self.Status = Status
    }
}
/*
 {
             "Id": "28",
             "UserId": "33",
             "Role": "0",
             "TrnType": "Credit",
             "Amount": "+30",
             "RemainingAmount": "40",
             "SupperCashAmount": "0",
             "RemainingSuperCashAmount": "0",
             "CODE": "",
             "TransactionId": "a",
             "Message": "Add Money To Wallet",
             "payMethod": "COD",
             "payStatus": "1",
             "payDate": "2021-01-19 19:09:22",
             "Type": "1",
             "OrderId": "0",
             "Status": "1"
         },
 */

public class PromoCode: Codable{
    var Id:String;
    var CODE:String;
    var Content:String
    init(Id: String, CODE: String, Content: String) {
        self.Id = Id
        self.CODE = CODE
        self.Content = Content
    }
}
/*
 "Id": "1",
 "CODE": "FIRST",
 "Content": "fdsdfsdf"
 */
public class Banner:NSObject, Codable{
    var Id:String;
    var BannerImg:String;
    var CategoryId:String
    var CategoryName:String
    init(Id: String, BannerImg: String,CategoryId: String, CategoryName: String,Price:String,Duration:String) {
        self.Id = Id
        self.BannerImg = BannerImg
        self.CategoryId = CategoryId
        self.CategoryName = CategoryName
    }
}

public class HomeBanner:NSObject, Codable{
    var Id:String;
    var BannerImg:String;
    init(Id: String, BannerImg: String) {
        self.Id = Id
        self.BannerImg = BannerImg
    }
}


// MARK: - WelcomeElement
class HomeProductCategory: Codable {
    let id, title: String
    let image, icon: String
    let product: [Product]

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title"
        case image = "Image"
        case icon = "Icon"
        case product
    }

    init(id: String, title: String, image: String, icon: String, product: [Product]) {
        self.id = id
        self.title = title
        self.image = image
        self.icon = icon
        self.product = product
    }
}

// MARK: - Product
class Product: Codable {
    let wishlist: Int
    let id, name: String
    let image: String
    let tax, veg, isVariable, brand: String
    let productDescription, avgRating: String
    let variation: [Variation]

    enum CodingKeys: String, CodingKey {
        case wishlist,id, name
        case image = "Image"
        case tax, veg, isVariable, brand
        case productDescription = "description"
        case avgRating = "AvgRating"
        case variation
    }

    init(wishlist: Int, id: String, name: String, image: String, tax: String, veg: String, isVariable: String, brand: String, productDescription: String, avgRating: String, variation: [Variation]) {
        self.wishlist = wishlist
        self.id = id
        self.name = name
        self.image = image
        self.tax = tax
        self.veg = veg
        self.isVariable = isVariable
        self.brand = brand
        self.productDescription = productDescription
        self.avgRating = avgRating
        self.variation = variation
    }
}

// MARK: - Variation
class Variation: Codable {
    let varID, attrID, attributeName, attrId1: String
    let attributeName1, sku: String
    let offerTag: JSONNull?
    let stock, pack: String
    let image: String
    let regularPrice: Int
    let salePrice, memberPrice: Double

    enum CodingKeys: String, CodingKey {
        case varID = "varId"
        case attrID = "attrId"
        case attributeName, attrId1, attributeName1
        case sku = "SKU"
        case offerTag, stock, pack, image
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case memberPrice = "member_price"
    }

    init(varID: String, attrID: String, attributeName: String, attrId1: String, attributeName1: String, sku: String, offerTag: JSONNull?, stock: String, pack: String, image: String, regularPrice: Int, salePrice: Double, memberPrice: Double) {
        self.varID = varID
        self.attrID = attrID
        self.attributeName = attributeName
        self.attrId1 = attrId1
        self.attributeName1 = attributeName1
        self.sku = sku
        self.offerTag = offerTag
        self.stock = stock
        self.pack = pack
        self.image = image
        self.regularPrice = regularPrice
        self.salePrice = salePrice
        self.memberPrice = memberPrice
    }
}


class TredningProduct: Codable {
    let id, name: String
    let image: String
    let veg, tax, isVariable, brand: String
    let welcomeDescription, avgRating: String
    let variation: [Variation]

    enum CodingKeys: String, CodingKey {
        case id, name
        case image = "Image"
        case veg, tax, isVariable, brand
        case welcomeDescription = "description"
        case avgRating = "AvgRating"
        case variation
    }

    init(id: String, name: String, image: String, veg: String, tax: String, isVariable: String, brand: String, welcomeDescription: String, avgRating: String, variation: [Variation]) {
        self.id = id
        self.name = name
        self.image = image
        self.veg = veg
        self.tax = tax
        self.isVariable = isVariable
        self.brand = brand
        self.welcomeDescription = welcomeDescription
        self.avgRating = avgRating
        self.variation = variation
    }
}

class HomeCategoryProduct: Codable {
    let id, title: String
    let image, icon: String
    let product: [Product]

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title"
        case image = "Image"
        case icon = "Icon"
        case product
    }

    init(id: String, title: String, image: String, icon: String, product: [Product]) {
        self.id = id
        self.title = title
        self.image = image
        self.icon = icon
        self.product = product
    }
}


class HomeParentCategoryModel: Codable {
    let id, title: String
    let image, icon: String
    let entDt, status: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title"
        case image = "Image"
        case icon = "Icon"
        case entDt = "EntDt"
        case status = "Status"
    }

    init(id: String, title: String, image: String, icon: String, entDt: String, status: String) {
        self.id = id
        self.title = title
        self.image = image
        self.icon = icon
        self.entDt = entDt
        self.status = status
    }
}

class NewArrivalModel: Product {
//    let wishlist: Int
//    let id, name: String
//    let image: String
//    let veg, tax, isVariable, brand: String
//    let welcomeDescription, avgRating: String
//    let variation: [Variation]
//
//    enum CodingKeys: String, CodingKey {
//        case wishlist, id, name
//        case image = "Image"
//        case veg, tax, isVariable, brand
//        case welcomeDescription = "description"
//        case avgRating = "AvgRating"
//        case variation
//    }
//
//    init(wishlist: Int, id: String, name: String, image: String, veg: String, tax: String, isVariable: String, brand: String, welcomeDescription: String, avgRating: String, variation: [Variation]) {
//        self.wishlist = wishlist
//        self.id = id
//        self.name = name
//        self.image = image
//        self.veg = veg
//        self.tax = tax
//        self.isVariable = isVariable
//        self.brand = brand
//        self.welcomeDescription = welcomeDescription
//        self.avgRating = avgRating
//        self.variation = variation
//    }
}

class BrandModel: Codable {
    let id, title: String
    let image: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title"
        case image = "Image"
        case status = "Status"
    }

    init(id: String, title: String, image: String, status: String) {
        self.id = id
        self.title = title
        self.image = image
        self.status = status
    }
}

class SearchModel: Codable {
    let id: String
    let name: String
   
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}




class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

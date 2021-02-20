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
    let regularPrice: Double
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

    init(varID: String, attrID: String, attributeName: String, attrId1: String, attributeName1: String, sku: String, offerTag: JSONNull?, stock: String, pack: String, image: String, regularPrice: Double, salePrice: Double, memberPrice: Double) {
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

// MARK: - Products
class Products: Codable {
    let wishlist: Int
    let id, name: String
    let image: String
    let tax, veg, isVariable, brand: String
    let productDescription, avgRating: String
    let variation: [Variation]

    enum CodingKeys: String, CodingKey {
        case wishlist,id, name
        case image = "image"
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


// MARK: - ProductDetail
class ProductDetail: Codable {
    let wishlist: Int
    let cart: Int
    let hSNCode: String
    let id, name: String
    let tax, veg, isVariable, brand: String
    let productDescription, avgRating: String
    let category:[String]
    let variation: [VariationInDetail]

    enum CodingKeys: String, CodingKey {
        case wishlist,id, name,cart
        case tax, veg, isVariable, brand
        case productDescription = "description"
        case avgRating = "AvgRating"
        case hSNCode = "HSNCode"
        case variation
        case category
    }

    init(wishlist: Int,cart: Int,hSNCode: String, id: String, name: String, tax: String, veg: String, isVariable: String, brand: String, productDescription: String, avgRating: String,category:[String], variation: [VariationInDetail]) {
        self.wishlist = wishlist
        self.id = id
        self.cart = cart
        self.hSNCode = hSNCode
        self.name = name
        self.tax = tax
        self.veg = veg
        self.isVariable = isVariable
        self.brand = brand
        self.productDescription = productDescription
        self.avgRating = avgRating
        self.category = category
        self.variation = variation
    }
}

// MARK: - VariationInDetail
class VariationInDetail: Codable {
    let varID, attrId1, sku : Int
    let attributeName, attrID: String
    let offerTag, stock, pack: Int
    let image: Int
    let regularPrice: Int
    let salePrice, memberPrice: Double
    let subvarieant: [Variation]


    enum CodingKeys: String, CodingKey {
        case varID = "varId"
        case attrID = "attrId"
        case attributeName, attrId1
        case sku = "SKU"
        case offerTag, stock, pack, image
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case memberPrice = "member_price"
        case subvarieant
    }

    init(varID: Int, attrID: String, attributeName: String, attrId1: Int, sku: Int, offerTag: Int, stock: Int, pack: Int, image: Int, regularPrice: Int, salePrice: Double, memberPrice: Double,subvarieant: [Variation]) {
        self.varID = varID
        self.attrID = attrID
        self.attributeName = attributeName
        self.attrId1 = attrId1
        self.sku = sku
        self.offerTag = offerTag
        self.stock = stock
        self.pack = pack
        self.image = image
        self.regularPrice = regularPrice
        self.salePrice = salePrice
        self.memberPrice = memberPrice
        self.subvarieant = subvarieant
    }
}

// MARK: - CartDetail
class CartDetail: Codable {
    let id,name,veg,tax,image,quantity,brand,isVariable : String
    let hSNCode,varID,attrID : String
    let attributeName,attrId1,attributeName1,pack,stock :String
    let sku :String
    let offerTag: JSONNull?
    let productDescription, avgRating: String
    let regularPrice,salePrice,memberPrice :Double

    enum CodingKeys: String, CodingKey {
        case id,name,veg,tax,image,quantity,brand,isVariable
        case hSNCode = "HSNCode"
        case varID = "varId"
        case attrID = "attrId"
        case attributeName,attrId1,attributeName1,stock,pack
        case sku = "SKU"
        case offerTag
        case productDescription = "description"
        case avgRating = "AvgRating"
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case memberPrice = "member_price"

    }
    
    init(id: String,name: String,veg: String,tax: String,image: String,quantity: String,brand: String,isVariable: String,hSNCode: String,varID: String,attrID: String,attributeName: String,attrId1: String,attributeName1: String,stock: String,pack: String,sku: String,offerTag: JSONNull?,productDescription: String,avgRating: String,regularPrice: Double,salePrice: Double,memberPrice: Double) {
        self.id = id
        self.name = name
        self.veg = veg
        self.tax = tax
        self.image = image
        self.quantity = quantity
        self.isVariable = isVariable
        self.brand = brand
        self.hSNCode = hSNCode
        self.varID = varID
        self.attrID = attrID
        self.attributeName = attributeName
        self.attrId1 = attrId1
        self.attributeName1 = attributeName1
        self.stock = stock
        self.pack = pack
        self.sku = sku
        self.offerTag = offerTag
        self.productDescription = productDescription
        self.avgRating = avgRating
        self.regularPrice = regularPrice
        self.salePrice = salePrice
        self.memberPrice = memberPrice
    }
}


// MARK: - Orders
class Orders: Codable {
    
    let id,diductionwallet,diductionsuperwallet,total,shipping : String
    let subTotal,couponCode,couponAmount,payMethod,placedDt :String
    let deliveryStatus,deliveryStatusName,shippingAddress : String
    let status,statusName :String
    let products : [ProductInOrder]

    enum CodingKeys: String, CodingKey {
        case id,diductionwallet,diductionsuperwallet,total,shipping,status,statusName
        case subTotal = "sub_total"
        case couponCode = "coupon_code"
        case couponAmount = "coupon_amount"
        case payMethod = "pay_method"
        case placedDt = "placed_dt"
        case deliveryStatus = "delivery_status"
        case deliveryStatusName = "delivery_status_name"
        case shippingAddress = "shipping_address"
        case products
    }
    
    init(id: String,diductionwallet: String,diductionsuperwallet: String,total: String,shipping: String,status: String,statusName: String,subTotal: String,couponCode: String,couponAmount: String,payMethod: String,placedDt: String,deliveryStatus: String,deliveryStatusName: String,shippingAddress: String,products:[ProductInOrder]) {
        self.id = id
        self.diductionwallet = diductionwallet
        self.diductionsuperwallet = diductionsuperwallet
        self.total = total
        self.shipping = shipping
        self.status = status
        self.statusName = statusName
        self.subTotal = subTotal
        self.couponCode = couponCode
        self.couponAmount = couponAmount
        self.payMethod = payMethod
        self.placedDt = placedDt
        self.deliveryStatus = deliveryStatus
        self.deliveryStatusName = deliveryStatusName
        self.shippingAddress = shippingAddress
        self.products = products
    }
}


// MARK: - ProductInOrder
class ProductInOrder: Codable {
    let productId,name,orderId,tax,image,quantity,statusDt,status : String
    let hSNCode,varID : String
    let attributeName,attributeName1,pack :String
    let sku :String
    let price :String

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case name,orderId,tax,image,quantity,statusDt,status
        case hSNCode = "HSNCode"
        case varID = "variation_id"
        case attributeName,attributeName1,pack
        case sku = "SKU"
        case price = "price"
    }
    
    init(productId: String,name: String,orderId: String,tax: String,image: String,quantity: String,statusDt: String,status: String,hSNCode: String,varID: String,attributeName: String,attributeName1: String,pack: String,sku: String,price: String) {
        self.productId = productId
        self.name = name
        self.orderId = orderId
        self.tax = tax
        self.image = image
        self.quantity = quantity
        self.status = status
        self.statusDt = statusDt
        self.hSNCode = hSNCode
        self.varID = varID
        self.attributeName = attributeName
        self.attributeName1 = attributeName1
        self.pack = pack
        self.sku = sku
        self.price = price
    }
}

class NotAvailableProduct: Codable {
    let id, name: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case image = "Image"
    }

    init(id: String, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}

class CreateOrder: Codable {
    let products: [CartDetail]
    let shippingAddress, shipping, couponCode, couponAmount: String
    let lat, lng, payMethod, userID: String
    let role, diductionwallet, diductionsuperwallet, dDt: String

    enum CodingKeys: String, CodingKey {
        case products
        case shippingAddress = "shipping_address"
        case shipping
        case couponCode = "coupon_code"
        case couponAmount = "coupon_amount"
        case lat = "Lat"
        case lng = "Lng"
        case payMethod = "pay_method"
        case userID = "user_id"
        case role, diductionwallet, diductionsuperwallet
        case dDt = "d_dt"
    }

    init(products: [CartDetail], shippingAddress: String, shipping: String, couponCode: String, couponAmount: String, lat: String, lng: String, payMethod: String, userID: String, role: String, diductionwallet: String, diductionsuperwallet: String, dDt: String) {
        self.products = products
        self.shippingAddress = shippingAddress
        self.shipping = shipping
        self.couponCode = couponCode
        self.couponAmount = couponAmount
        self.lat = lat
        self.lng = lng
        self.payMethod = payMethod
        self.userID = userID
        self.role = role
        self.diductionwallet = diductionwallet
        self.diductionsuperwallet = diductionsuperwallet
        self.dDt = dDt
    }
}



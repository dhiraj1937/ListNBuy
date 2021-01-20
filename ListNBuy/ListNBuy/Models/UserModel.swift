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

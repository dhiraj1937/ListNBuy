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


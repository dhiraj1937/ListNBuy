//
//  ApiManager.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit
import Alamofire
import SwiftyJSON

private var webView = UIWebView(frame: CGRect.zero)
private var secretAgent: String? = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
var authHeaders: HTTPHeaders = ["User-Agent": secretAgent!, "Content-Type": "application/json; charset=utf-8"]

class ApiManager: NSObject {
    
    static let sharedInstance = ApiManager()
    func requestGETURL(_ strURL: String,success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        let headerS: HTTPHeaders = ["x-api-key": Constant.APIKey]
        
        AF.request(strURL, method: .get, headers: headerS).responseJSON{ response in
            
            switch response.result {
            case let .success(result):
                success(JSON(result))
            case let .failure(error):
                failure(error)
            }
        };
        
    }
    
    func requestPOSTURL(_ strURL: String, params: [String : Any]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let headerS: HTTPHeaders = ["x-api-key": Constant.APIKey]
        AF.request(strURL, method: .post, parameters: params, headers: headerS).responseJSON  { response in
            switch response.result {
            case let .success(result):
                success(JSON(result))
                
            case let .failure(error):
                failure(error)
            }
            
        }
        
    }
    
    
    func requestPOSTMultiPartURL(endUrl: String, imageData: Data?, parameters: [String : Any], success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void){
        
        let headers: HTTPHeaders = [
            "x-api-key": Constant.APIKey,
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if(key != "ProfileImage" || key != "Image"){
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                if let data = imageData{
                    multipartFormData.append(data, withName: "ProfileImage", fileName: "image.png", mimeType: "image/png")
                }        },
            to: endUrl, method: .post , headers: headers)
            .response { resp in
                if(resp.error==nil){
                    let str = String(decoding: resp.data!, as: UTF8.self)
                    success(JSON(str))
                }
                else{
                    failure(resp.error as! Error)
                }
        }
        
    }
    
    func requestPOSTMultiPartURL(endUrl: String, imageData: Data?, parameters: [String : Any],imageParam:String, success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void){
        
        let headers: HTTPHeaders = [
            "x-api-key": Constant.APIKey,
            "Content-type": "multipart/form-data"
        ]
        
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if(key != imageParam){
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                
                if let data = imageData{
                    multipartFormData.append(data, withName: imageParam, fileName: "image.png", mimeType: "image/png")
                }
                
        },
            to: endUrl, method: .post , headers: headers)
            .response { resp in
                if(resp.error==nil){
                    let str = String(decoding: resp.data!, as: UTF8.self)
                    success(JSON(str))
                }
                else{
                    failure(resp.error as! Error)
                }
        }
       
    }
    
    func requestPOSTFreelancerMultiPartURL(endUrl: String, imageData: Data?,cardData: Data?, parameters: [String : Any], success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void){
        
        let headers: HTTPHeaders = [
            "x-api-key": Constant.APIKey,
            "Content-type": "multipart/form-data"
        ]
        
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if(key != "ProfileImage" && key != "IdProof"){
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }
                
                if let data = imageData{
                    multipartFormData.append(data, withName: "ProfileImage", fileName: "image.png", mimeType: "image/png")
                }
                
                if let cdata = cardData{
                    multipartFormData.append(cdata, withName: "IdProof", fileName: "CardImage.png", mimeType: "image/png")
                }
                
        },
            to: endUrl, method: .post , headers: headers)
            .response { resp in
                if(resp.error==nil){
                    let str = String(decoding: resp.data!, as: UTF8.self)
                    success(JSON(str))
                }
                else{
                    failure(resp.error as! Error)
                }
        }
       
    }
}

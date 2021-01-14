//
//  WebViewController.swift
//  ListNBuy
//
//  Created by Team A on 14/01/21.
//

import Foundation
import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON
import WebKit

class WebViewController: UIViewController {
    @IBOutlet var webview:WKWebView!
    public var urlString:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlString!){
                webview.load(URLRequest(url: url))
        }
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
}

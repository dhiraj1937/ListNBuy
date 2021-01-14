//
//  FAQsViewController.swift
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

class FAQsViewController: UIViewController {
    @IBOutlet var lblTitle:UILabel!

    public var headertitle:String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = headertitle;
        //let test:LoginUserData = self.UnArchivedUserDefaultObject(key: "LoginUserData") as! LoginUserData
        //print(test.Name)
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
}

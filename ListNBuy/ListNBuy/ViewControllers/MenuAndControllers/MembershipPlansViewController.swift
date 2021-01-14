//
//  MembershipPlansViewController.swift
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

class MembershipPlansViewController: UIViewController {
    @IBOutlet var lblTitle:UILabel!

    public var headertitle:String!;
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = headertitle;
    }
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
}
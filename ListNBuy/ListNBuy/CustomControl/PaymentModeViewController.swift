//
//  PaymentModeViewController.swift
//  ListNBuy
//
//  Created by Team A on 14/02/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

protocol PaymentModeButtonsDelegate{
    func btnSelectedWithMode(mode:String)
}

class PaymentModeViewController: UIViewController {
    @IBOutlet var lblPaybleAmount:UILabel!
    @IBOutlet var btnOnline:UIButton!
    @IBOutlet var btnPOD:UIButton!
    public var amount:String!
    var navigation:UINavigationController!
    var delegate:PaymentModeButtonsDelegate!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPaybleAmount.text = "Payble amount is: "+amount
    }
    
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnONLINE_Click(){
        close()
        self.delegate.btnSelectedWithMode(mode: "ONLINE")
    }
    @IBAction func btnPOD_Click(){
        self.delegate.btnSelectedWithMode(mode: "POD")
        close()
    }

}

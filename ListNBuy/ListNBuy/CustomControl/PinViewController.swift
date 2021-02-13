//
//  PinViewController.swift
//  ListNBuy
//
//  Created by Team A on 17/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

protocol PinViewButtonDelegate{
    func submitPin(pin:String,responseReturn:@escaping (String) -> Void)
}

class PinViewController: UIViewController {

    @IBOutlet var txtPin:UITextField!
    var navigation:UINavigationController!
    var delegate:PinViewButtonDelegate!
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
    }
    
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSubmit_Click(){
        if(txtPin.text?.count==0){
            LPSnackbar.showSnack(title: "Please enter pin code.")
            return
        }
        self.delegate.submitPin(pin: txtPin.text!){ (responseReturn) in
            if responseReturn == "PASS"{
                UserDefaults.standard.setUserPin(value:self.txtPin.text!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

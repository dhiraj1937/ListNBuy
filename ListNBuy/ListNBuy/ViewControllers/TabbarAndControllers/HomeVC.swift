//
//  HomeVC.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnWhatsAppAvailabitliy(){
        let vc = WhatsAppOrderViewController.init(nibName: "WhatsAppOrderViewController", bundle: nil)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}


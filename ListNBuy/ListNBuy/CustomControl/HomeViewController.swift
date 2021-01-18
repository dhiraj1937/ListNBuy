//
//  HomeViewController.swift
//  ListNBuy
//
//  Created by Apple on 18/01/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var txtSearch:UITextField!
    @IBOutlet var viewBanner:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnWhatsAppAvailabitliy(){
        let vc = WhatsAppOrderViewController.init(nibName: "WhatsAppOrderViewController", bundle: nil)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

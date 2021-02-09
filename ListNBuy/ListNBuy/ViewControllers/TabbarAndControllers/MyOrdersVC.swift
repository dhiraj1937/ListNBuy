//
//  MyOrdersVC.swift
//  ListNBuy
//
//  Created by Team A on 07/01/21.
//

import UIKit


class MyOrdersVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Helper.getCartListAPI { (res) in
            if(res){
                self.AddCartView(view: self.view)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        RemoveCart(view: self.view)
    }

}


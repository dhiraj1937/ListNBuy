//
//  CheckOutViewController.swift
//  ListNBuy
//
//  Created by Team A on 04/02/21.
//

import UIKit

class CheckOutViewController: UIViewController {
    
    @IBOutlet weak var lblMRPVal:UILabel!
    @IBOutlet weak var lblDeliveryChargeVal:UILabel!
    @IBOutlet weak var lblTotalVal:UILabel!
    @IBOutlet weak var txtFPromoCode:UITextField!
    @IBOutlet weak var btnApply:UIButton!
    @IBOutlet weak var btnPayNow:UIButton!
    @IBOutlet weak var tblItemList:UITableView!

    var listProducts:[Products] = [Products]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(sender:UIButton){
        self.navigationController?.popViewController(animated: true);
    }
    
   
    @IBAction func btnRemoveItem(sender:UIButton){
        
    }
    @IBAction func btnAddItemQByOne(sender:UIButton){
        
    }
    @IBAction func btnRemoveItemQByOne(sender:UIButton){
        
    }
    
    @IBAction func btnApplyPromoCode(sender:UIButton){
        
    }

    @IBAction func btnPayNow(sender:UIButton){
        
    }

}

extension CheckOutViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutCell")!
        return cell;
    }
    
    
    
}

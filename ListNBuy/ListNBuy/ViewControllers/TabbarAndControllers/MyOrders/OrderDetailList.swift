//
//  OrderDetailList.swift
//  ListNBuy
//
//  Created by Rajesh Jayaswal on 10/02/21.
//

import UIKit

class OrderDetailList: UIViewController {
    @IBOutlet weak var tblItemList:UITableView!
    var listProducts:[CartDetail] = [CartDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func btnBack(sender:UIButton){
        self.navigationController?.popViewController(animated: true);
    }
}
extension OrderDetailList: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutCell")  as! CheckOutCell
        cell.SetData(cd:listProducts[indexPath.row])
        return cell;
    }
}

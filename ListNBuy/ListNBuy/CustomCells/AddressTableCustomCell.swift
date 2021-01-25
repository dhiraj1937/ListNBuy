//
//  AddressTableCustomCell.swift
//  ListNBuy
//
//  Created by Team A on 24/01/21.
//

import UIKit

protocol ActionButtonDelegate{
    func EditTapped(at index:IndexPath)
    func DeleteTapped(at index:IndexPath)
}


class AddressTableCustomCell: UITableViewCell {
    
    @IBOutlet var imgType:UIImageView?
    @IBOutlet var lblAddress:UILabel?
    @IBOutlet var lblTitle:UILabel?
    @IBOutlet var btnEdit:UIButton?
    @IBOutlet var btnDelete:UIButton?
    var indexPath:IndexPath!
    var delegate:ActionButtonDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetData(add:String,icon:String){
        lblAddress?.text = add;
        imgType?.image = UIImage.init(named: "icon")
    }
    
    @IBAction func EditButtonTapped(_ sender: UIButton) {
        self.delegate.EditTapped(at: indexPath)
       }
    
    @IBAction func DeleteButtonTapped(_ sender: UIButton) {
        self.delegate.DeleteTapped(at: indexPath)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

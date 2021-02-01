//
//  ProductDetailViewController.swift
//  ListNBuy
//
//  Created by Team A on 31/01/21.
//

import UIKit
import Alamofire
import LPSnackbar
import PKHUD
import SwiftyJSON

class ProductDetailViewController: UIViewController {
    public var productId:String!
    var selectedMou: String?
    var selectedVariant: String?
    var selectedPicker:Int = 0
    var arrPicker:[String] = [String]()
    var arrMous:[String] = ["testmou1","testmou2"]
    var arrVariants:[String] = ["testVar1","testVar2"]
    
    @IBOutlet weak var btnShowCart:UIButton!
    @IBOutlet weak var imgProductImage:UIImageView!
    @IBOutlet weak var lblProductName:UILabel!
    @IBOutlet weak var lblRate:UILabel!
    @IBOutlet weak var lblActualRate:UILabel!
    @IBOutlet weak var btnAddToWishlist:UIButton!
    @IBOutlet weak var lblDesc:UILabel!
    @IBOutlet weak var btnAddToCart:UIButton!

    @IBOutlet weak var pickerView :UIPickerView!
    @IBOutlet weak var btnDropDownMou:UIButton!
    @IBOutlet weak var btnDropDownVariant:UIButton!
    @IBOutlet weak var viewPickerContainer:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        btnDropDownMou.setTitle("Select", for: .normal)
        btnDropDownVariant.setTitle("Select", for: .normal)
        getProductDetails()
    }
    
    @IBAction func btnBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDropDownMouAction(){
        showPickerView(pickerFor:"MOU")
    }
    @IBAction func btnDropDownVariantAction(){
        showPickerView(pickerFor:"VARIANT")
    }
    @IBAction func btnDoneForDismissPicker(){
        dismissPickerView()
    }
    @IBAction func btnAddToCartAction(){
    }
    @IBAction func btnShowCartAction(){
    }
    @IBAction func btnAddToWishlistAction(){
    }

    
    func getProductDetails() {

        if KAPPDELEGATE.isNetworkAvailable(){
            DispatchQueue.main.async {
                HUD.show(.progress)
            }
            
            let userID = UserDefaults.standard.getUserID()
            
            ApiManager.sharedInstance.requestGETURL(Constant.getProductDetailsURL+""+"183"+""+userID, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                print(msg as Any)
                if((JSON.dictionary?["IsSuccess"]) != false){
               // subvarieant > "image"
               // "name": "COLGATE TOOTH POWDER",
               // "description": "COLGATE TOOTH POWDER 100g",
               // "variation"> "attributeName": "No Variant",
               // subvarieant > regular_price
               // subvarieant > member_price
                    HUD.flash(.progress)
                }
                DispatchQueue.main.async {
                    HUD.flash(.progress)
                }
            }, failure: { (Error) in
            DispatchQueue.main.async {
                HUD.flash(.error)
                LPSnackbar.showSnack(title: AlertMsg.APIFailed)
            }
           })
       }
        else{
            LPSnackbar.showSnack(title: AlertMsg.warningToConnectNetwork)
        }
    }
}
extension ProductDetailViewController:  UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedPicker == 1 {
            selectedMou = arrPicker[row] // selected item
            btnDropDownMou.setTitle(selectedMou, for: .normal)
        }else if selectedPicker == 2 {
            selectedVariant = arrPicker[row]
            btnDropDownVariant.setTitle(selectedVariant, for: .normal)
        }
            
    }
    
    func showPickerView(pickerFor:String) {
        
        arrPicker.removeAll()
        
        if pickerFor == "MOU" {
            selectedPicker = 1
            arrPicker.append(contentsOf: arrMous)
        }else{
            selectedPicker = 2
            arrPicker.append(contentsOf: arrVariants)
        }
        viewPickerContainer.isHidden = false
        pickerView.reloadAllComponents()
    }
    
    func dismissPickerView() {
        viewPickerContainer.isHidden = true
    }
    
}

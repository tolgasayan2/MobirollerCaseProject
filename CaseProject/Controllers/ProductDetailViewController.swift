//
//  ProductDetailViewController.swift
//  CaseProject
//
//  Created by Tolga Sayan on 14.10.2021.
//

import UIKit

class ProductDetailViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var infoView: UITextView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  var category = ""
  var info = ""
  var name = ""
  var date = ""
  var price = ""
  var product = Product()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    categoryLabel.text = category
    nameLabel.text = name
    infoView.text = info
    dateLabel.text = date
    priceLabel.text = "\(price) TL"
    
    priceLabel.font = .boldSystemFont(ofSize: 17)
    categoryLabel.font = .boldSystemFont(ofSize: 17)
    nameLabel.font = .boldSystemFont(ofSize: 17)
    dateLabel.font = .boldSystemFont(ofSize: 17)
    priceLabel.font = .boldSystemFont(ofSize: 17)
    infoView.font = .boldSystemFont(ofSize: 15)
  }
}

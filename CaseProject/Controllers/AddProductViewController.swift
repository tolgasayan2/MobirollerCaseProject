//
//  AddProductViewController.swift
//  CaseProject
//
//  Created by Tolga Sayan on 14.10.2021.
//

import UIKit
import FirebaseDatabase

protocol AddProductViewControllerDelegate: AnyObject {
  func addProductViewControllerDidCancel(_ controller: AddProductViewController)
  func addProductViewController(_ controller: AddProductViewController, didFinishAdding product: Product )
  func addIProductViewController(_ controller: AddProductViewController, didFinishEditing product: Product)
}

class AddProductViewController: UITableViewController, UITextFieldDelegate {
  
  private let database = Database.database().reference().child("products")
  
  weak var delegate: AddProductViewControllerDelegate?
  var editProduct: Product?
  var product = Product()
  let date = Date()
  let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var priceTextField: UITextField!
  @IBOutlet weak var infoView: UITextView!
  @IBOutlet weak var dateTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createDatePicker()
    
    //MARK: - Edit Page
    
    if let product = editProduct {
      title = "Ürün Düzenle"
      categoryTextField.text = product.category
      nameTextField.text = product.name
      priceTextField.text = product.price
      infoView.text = product.info
      dateTextField.text = product.date
      doneBarButton.isEnabled = true
    }
    
    navigationItem.largeTitleDisplayMode = .never
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    categoryTextField.becomeFirstResponder()
  }
  
  //MARK: - UIDatePicker Events
  func createDatePicker() {
    let toolbar = UIToolbar()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: nil,
                                     action: #selector(donePressed)
    )
    
    toolbar.sizeToFit()
    toolbar.setItems([doneButton], animated: true)
    
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.datePickerMode = .date
    dateTextField.inputView = datePicker
    dateTextField.inputAccessoryView = toolbar
  }
  
  @objc func donePressed() {
    let formatter = DateFormatter()
    
    formatter.dateFormat = "dd/MM/yyyy"
    dateTextField.text = formatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
  
  //MARK: - Actions
  @IBAction func done(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    
    if let product = editProduct {
      product.category = categoryTextField.text!
      product.price = priceTextField.text!
      product.info = infoView.text!
      product.date = dateTextField.text!
      product.name = nameTextField.text!
      
      let id = product.id
      let editedProduct = ["category": categoryTextField.text!,
                           "name": nameTextField.text!,
                           "price": priceTextField.text!,
                           "info": infoView.text!,
                           "date": dateTextField.text!,
                           "id": id
      ]
      
      database.child(id).setValue(editedProduct) //Edit Product on Database
      delegate?.addIProductViewController(self, didFinishEditing: product)
    } else {
      let key = database.childByAutoId().key
      let newProduct = ["category": categoryTextField.text!,
                        "name": nameTextField.text!,
                        "price": priceTextField.text!,
                        "info": infoView.text!,
                        "date": dateTextField.text!,
                        "id": key
      ]
      
      database.child(key!).setValue(newProduct) // Add Product on Database
      delegate?.addProductViewController(self, didFinishAdding: product)
    }
  }
  
  @IBAction func cancel(_ sender: Any) {
    navigationController?.popViewController(animated: true)
    
    delegate?.addProductViewControllerDidCancel(self)
  }
  
  
  //MARK: - TextField Delegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = [categoryTextField.text!,nameTextField.text!,priceTextField.text!,infoView.text!,dateTextField.text!]
    
    for i in oldText {
      let stringRange = Range(range, in: i)!
      let newText = i.replacingCharacters(in: stringRange, with: string)
      
      doneBarButton.isEnabled = !newText.isEmpty
    }
    return true
  }
}

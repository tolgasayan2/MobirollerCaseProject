//
//  ProductsViewController.swift
//  CaseProject
//
//  Created by Tolga Sayan on 13.10.2021.
//

import UIKit
import FirebaseDatabase

class ProductsViewController: UITableViewController, AddProductViewControllerDelegate {
  
  private let database = Database.database().reference().child("products")
  
  var products = [Product]()
  var product = Product()
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
    
    tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    
    
    loadProducts()
    
    
  }
  
  
  @IBAction func orderButton(_ sender: UIBarButtonItem) {
    sender.tag += 1
    if sender.tag > 2 { sender.tag = 0 }
    
    switch sender.tag {
    case 1:
     products =  products.sorted(by: {$0.date < $1.date})
    case 2:
     products =  products.sorted(by: {$0.date > $1.date})
    default:
     products =  products.sorted(by: {$0.date > $1.date})
    }
      tableView.reloadData()
   }
  
  
  //MARK: - Firebase Retrieve Data
  
  func loadProducts(){
    database.observe(DataEventType.value) { snapshot in
      if snapshot.childrenCount > 0 {
        self.products.removeAll()
        
        for product in snapshot.children.allObjects as! [DataSnapshot]{
          let productObject = product.value as? [String: AnyObject]
          let product = Product(category: productObject?["category"] as! String, price: productObject?["price"] as! String, name: productObject?["name"] as! String, info: productObject?["info"] as! String, date: productObject?["date"] as! String, id: productObject?["id"] as! String)
          self.products.append(product)
        }
      }
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
      
    }
  }
  
  
  //MARK: - AddProductViewController Delegate Methods
  
  func addProductViewControllerDidCancel(_ controller: AddProductViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func addProductViewController(_ controller: AddProductViewController, didFinishAdding product: Product) {
    
    let newRowIndex = products.count
    products.append(product)
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let arrayOfIndexPath = [indexPath]
    tableView.insertRows(at: arrayOfIndexPath, with: .automatic)
    navigationController?.popViewController(animated: true)
    
    
  }
  
  func addIProductViewController(_ controller: AddProductViewController, didFinishEditing product: Product) {
    
    if let index = products.firstIndex(of: product) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
        cell.nameLabel.text = product.name
      }
      navigationController?.popViewController(animated: true)
    }
  }
  //MARK: - TableView Data Source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell {
      let product = products[indexPath.row]
      cell.nameLabel.text = product.name
      cell.categoryLabel.text = product.date
      cell.accessoryType = .detailDisclosureButton
      
      return cell
    }
    
    
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    let id = products[indexPath.row].id //FirebaseDatabase Remove product 
    database.child(id).setValue(nil)
    
    self.products.remove(at: indexPath.row)
    let indexPathArray = [indexPath]
    tableView.deleteRows(at: indexPathArray, with: .automatic)
    
    
    
    
    
    
    
  }
  
  //MARK: - TableView Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let product = products[indexPath.row]
    performSegue(withIdentifier: "toProductDetailVC", sender: product)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let controller = storyboard!.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
    controller.delegate = self
    
    let product = products[indexPath.row]
    controller.editProduct = product
    
    navigationController?.pushViewController(controller, animated: true)
  }
  
  
  
  
  
  //MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toAddProductVC" {
      let controller = segue.destination as! AddProductViewController
      controller.delegate = self
    } else if segue.identifier == "toEditProductVC"{
      let controller = segue.destination as! AddProductViewController
      controller.delegate = self
      
      if let indexPath = tableView.indexPath(
        for: sender as! UITableViewCell) {
        controller.editProduct = products[indexPath.row]
        
      }
      
      
      
      
    } else if segue.identifier == "toProductDetailVC" {
      guard let indexPath = tableView.indexPathForSelectedRow else {return}
      let product = products[indexPath.row]
      let controller = segue.destination as! ProductDetailViewController
      
      controller.category = product.category
      controller.info = product.info
      controller.price = String(product.price)
      controller.date = product.date
      controller.name = product.name
      
    }
    
  }
  
}


  





//
//  Product.swift
//  CaseProject
//
//  Created by Tolga Sayan on 13.10.2021.
//

import Foundation

class Product: NSObject {

  var category = ""
  var price = ""
  var name = ""
  var info = ""
  var date = ""
  var id = ""
  
  internal init(category: String = "", price: String = "", name: String = "", info: String = "", date: String = "", id: String = "") {
    self.category = category
    self.price = price
    self.name = name
    self.info = info
    self.date = date
    self.id = id
  }
  
  
  
}




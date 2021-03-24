//
//  ListTVController.swift
//  YuChe_MyOrder
//
//  Created by YuChe Liu on 2021/2/15.

import UIKit
class ListTVController: UITableViewController {
//    var coffeeSet = [Coffee]()
    
    private var coffeeList : [MyOrder] = [MyOrder]()
    private let dbHelper = DatabaseHelper.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAllCoffee()
        self.tableView.rowHeight = 70
        
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coffeeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list_cell", for: indexPath) as! ListTableViewCell
        let coffee = coffeeList[indexPath.row]
        cell.lblQuan.text = String(coffee.quantity)
        cell.lblType.text = coffee.type
        cell.lblSize.text = coffee.size
        return cell
    }
    
    // A3 New Parts
    //delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (indexPath.row < self.coffeeList.count){
            self.deleteCOffeeFromList(indexPath: indexPath)
        }
    }
    private func deleteCOffeeFromList(indexPath: IndexPath){
        self.dbHelper.deleteCoffee(coffeeID: self.coffeeList[indexPath.row].id!)
        self.fetchAllCoffee()
    }
    //update
    

    
    private func fetchAllCoffee(){
        if (self.dbHelper.getAllCoffee() != nil){
            self.coffeeList = self.dbHelper.getAllCoffee()!
            self.tableView.reloadData()
        }else{
            print(#function, "No data recieved from dbHelper")
        }
    }
}

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
        self.setUpLongPressGesture()
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
            self.deleteCoffeeFromList(indexPath: indexPath)
        }
    }
    private func deleteCoffeeFromList(indexPath: IndexPath){
        self.dbHelper.deleteCoffee(coffeeID: self.coffeeList[indexPath.row].id!)
        self.fetchAllCoffee()
    }
    //update
    private func updateCoffee(indexPath: IndexPath,quantity: Int32){
        self.dbHelper.updateCoffee(updatedCoffee: self.coffeeList[indexPath.row],nquantity: quantity)
        self.fetchAllCoffee()
    }
    
    private func setUpLongPressGesture(){
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1 //1 second
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    @objc
    private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended{
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint){
                self.displayUpdateCoffeeAlert(indexPath: indexPath, title: "Edit Quantity", message: "Please provide the updated number for this coffee order")
            }
        }
    }
    
    private func displayUpdateCoffeeAlert(indexPath: IndexPath?, title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField{(textField: UITextField) in
            textField.text = String(self.coffeeList[indexPath!.row].quantity)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
            if let quantityText = alert.textFields?[0].text {
                // break when entering chars
                self.dbHelper.updateCoffee(updatedCoffee: self.coffeeList[indexPath!.row], nquantity: Int32(quantityText)! ?? 0 )
                self.fetchAllCoffee()
            }
        }) )
        self.present(alert, animated: true, completion: nil)
    }
    
    private func fetchAllCoffee(){
        if (self.dbHelper.getAllCoffee() != nil){
            self.coffeeList = self.dbHelper.getAllCoffee()!
            self.tableView.reloadData()
        }else{
            print( "No data recieved from dbHelper")
        }
    }
}

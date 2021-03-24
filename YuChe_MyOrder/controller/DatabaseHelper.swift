//
//  DatabaseHelper.swift
//  YuChe_MyOrder
//
//  Created by 劉宇哲YUCHE LIU on 2021/3/24.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper{
    private static var shared : DatabaseHelper?
    static func getInstance() -> DatabaseHelper{
        if shared != nil{
            return shared!
            
        }else{
            return DatabaseHelper( context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        }
    }
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "MyOrder"
    
    private init (context : NSManagedObjectContext){
        self.moc = context
    }

    // insert
    func insertCoffee(newCoffee : Coffee ){
        do{
            let coffeeTobeAdded = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! MyOrder
            coffeeTobeAdded.size = newCoffee.size
            coffeeTobeAdded.quantity = newCoffee.quantity
            coffeeTobeAdded.id = UUID()
            coffeeTobeAdded.createdDate = Date()
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Coffee Data inserted successfully")
            }
        }catch let error as NSError{
            print(#function, "Could not save the data \(error) ")
        }
    }
    // search
    func searchTask(taskID : UUID) ->MyOrder?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "id == %@", taskID as CVarArg)
        fetchRequest.predicate = predicateID
        
        do{
            
            let result = try self.moc.fetch(fetchRequest)
            
            if result.count > 0{
                return result.first as? MyOrder
            }
            
        }catch let error as NSError{
            print("Unable to search coffee \(error)")
        }
        
        return nil
    }
    
    // update
    func updateTask(updatedCoffee: MyOrder){
        let searchResult = self.searchTask(taskID: updatedCoffee.id! as UUID)
        
        if (searchResult != nil){
            do{
                let coffeeToUpdate = searchResult!
                
                
                try self.moc.save()
                print(#function, "Task updated successfully")
                
            }catch let error as NSError{
                print(#function, "Unable to search coffee \(error)")
            }
        }
    }

    
    
    //retreive
    func getAllCoffee() -> [MyOrder]?{
        let fetchRequest = NSFetchRequest<MyOrder>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dateCreated", ascending: true)]
        
        do{
            let result = try self.moc.fetch(fetchRequest)
            print(#function, "Fetched data : \(result as [MyOrder])")
            return result as [MyOrder]
            
        }catch let error as NSError{
            print("Could not fetch data \(error) \(error.code)")
        }
        return nil
    }


    
}

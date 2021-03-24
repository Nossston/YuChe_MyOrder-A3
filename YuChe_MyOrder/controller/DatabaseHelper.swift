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

    
    
    
    //
    func getAllTodos() -> [MyOrder]?{
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

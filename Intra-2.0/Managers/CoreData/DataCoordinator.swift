//
//  DataCoordinator.swift
//  Intra-2.0
//
//  Created by admin on 11.03.2020.
//  Copyright © 2020 Rinat Kutuev. All rights reserved.
//

import CoreData

final class DataCoordinator {
    private static var coordinator: DataCoordinator?
    
    /// Singleton to manage the core data stack
    public class func sharedInstance() -> DataCoordinator {
        if coordinator == nil {
            coordinator = DataCoordinator()
        }
        return coordinator!
    }
    
    public var container: NSPersistentContainer
    
    private init() {
        let name = ""
        container = NSPersistentContainer(name: name)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
    }
    
    /*
     To write all we have to do is
        DataCoordinator.performBackgroundTask { (context) in
        }
     */
    
    /// write
    static func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> (Void)) {
        DataCoordinator.sharedInstance().container.performBackgroundTask(block)
    }
    
    /*
     To read all we have to do is
     Make sure to use DispatchQueue.main.async or DispatchQueue.main.syncbefore using this method when working from threads.
     DispatchQueue.main.async {
         DataCoordinator.performViewTask { (context) in
         }
     }
     */
    
    /// read
    static func performViewtask(_ block: @escaping (NSManagedObjectContext) -> (Void)) {
        block(DataCoordinator.sharedInstance().container.viewContext)
    }
}

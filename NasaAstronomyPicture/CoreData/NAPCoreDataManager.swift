//
//  NAPCoreDataManager.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 03/09/22.
//

import Foundation
import CoreData

// This Snigalon class is responsible to do CRUD operation on CoreData over Asset History data.
final class NAPCoreDataManager {
    
    private static let dbName = "NasaAstrology"
    static let shared = NAPCoreDataManager()
    private init() {    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: NAPCoreDataManager.dbName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension NAPCoreDataManager {
    /// Method to return DB entity
    /// - Parameter entity: Entity name
    /// - Parameter context: The managed object context to use. Must not be nil.
    /// - Returns: New object for `entity` name
    private func createRecordForEntity(_ entity: String,
                                       forContext context: NSManagedObjectContext) -> NSManagedObject? {
        var result: NSManagedObject?
        if let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: context) {
            result = NSManagedObject(entity: entityDescription, insertInto: context)
        }
        return result
    }
    
    /// Function to insert the data to DB
    public func insertImageData(_ model: NAPFetchImageResponse) {
        if let dbItem = self.createRecordForEntity("ImageOfTheDay",
                                                   forContext: self.context) as? ImageOfTheDay {
            dbItem.title = model.title
            dbItem.explanation = model.explanation
            dbItem.date = model.date
            dbItem.url = model.url
            dbItem.hdurl = model.hdurl
            dbItem.mediaType = model.mediaType?.rawValue
            dbItem.isBookmarked = model.isBookmarked
        }
        saveContext()
    }
    
    /// Function to change the status of bookmark in DB
    func changeBookmarkStatus(_ isBookmarked: Bool, date: String) {
        let fetchRequest = NSFetchRequest<ImageOfTheDay>(entityName: "ImageOfTheDay")
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        
        do {
            if let response = try self.context.fetch(fetchRequest).first {
                response.isBookmarked = isBookmarked
            }
        } catch {
            Logger.e("Error fetching the Logs entity: \(error)")
        }
        saveContext()
    }
    
    /// Function to check if record already exists
    func fetchRecordIfExists(_ date: String) -> NAPFetchImageResponse? {
        let fetchRequest = NSFetchRequest<ImageOfTheDay>(entityName: "ImageOfTheDay")
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        
        do {
            if let response = try self.context.fetch(fetchRequest).first {
                return NAPFetchImageResponse(isBookmarked: response.isBookmarked,
                                             id: nil,
                                             date: response.date,
                                             explanation: response.explanation,
                                             hdurl: response.hdurl,
                                             mediaType: NAPMediaType(rawValue: response.mediaType ?? "image"),
                                             serviceVersion: nil,
                                             title: response.title,
                                             url: response.url)
            } else {
                return nil
            }
        } catch {
            Logger.e("Error fetching the Logs entity: \(error)")
        }
        return nil
    }
    
    /// Function to fetch all the bookmark records
    func fetchAllBookmarkedRecords() -> [ImageOfTheDay]? {
        let fetchRequest = NSFetchRequest<ImageOfTheDay>(entityName: "ImageOfTheDay")
        fetchRequest.predicate = NSPredicate(format: "isBookmarked == true")
        
        do {
            return try self.context.fetch(fetchRequest)
        } catch {
            Logger.e("Error fetching the Logs entity: \(error)")
        }
        return nil
    }
}

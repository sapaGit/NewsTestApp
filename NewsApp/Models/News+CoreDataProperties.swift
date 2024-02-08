//
//  News+CoreDataProperties.swift
//  NewsApp
//

//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var title: String?
    @NSManaged public var creator: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var pubDate: String?
    @NSManaged public var newsID: String?
    @NSManaged public var sourceURL: String?

}

extension News : Identifiable {

}

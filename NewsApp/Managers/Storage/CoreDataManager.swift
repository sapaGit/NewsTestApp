//
//  CoreDataManager.swift
//  NewsApp
//


import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()

    let persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (storeDescrition, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistantContainer.viewContext
    }
    
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadNews(completion: (Result<[News], Error>) -> Void) {
        do {
            let news = try viewContext.fetch(News.fetchRequest())
            completion(.success(news))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func saveNews(newsData: NewsData, completion: () -> Void) {
        let news = News(context: viewContext)
        news.title = newsData.title
        news.creator = newsData.creator?.first
        news.imageURL = newsData.imageURL
        news.pubDate = newsData.pubDate
        news.descriptionText = newsData.description
        news.newsID = newsData.articleID
        news.sourceURL = newsData.sourceURL
        saveContext()
        completion()
    }
    
    func delete(newsData: NewsData, completion: () -> Void) {
        loadNews { result in
            switch result {
            case .success(let news):
                for article in news {
                    if article.newsID == newsData.articleID {
                        viewContext.delete(article)
                        saveContext()
                        completion()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

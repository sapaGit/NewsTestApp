//
//  UITabBarItem+extension.swift
//  NewsApp
//

import UIKit

enum TabDetail: Int {
    case news
    case favorites

    var title: String {
        switch self {
        case .news:
            return "News"
        case .favorites:
            return "Favorites"
        }
    }

    var image: UIImage {
        switch self {
        case .news:
            return UIImage(systemName: "newspaper")!
        case .favorites:
            return UIImage(systemName: "star")!
        }
    }
}

extension UITabBarItem {
    convenience init(_ tabDetails: TabDetail) {
        self.init(title: tabDetails.title, image: tabDetails.image, tag: tabDetails.rawValue)
    }
}

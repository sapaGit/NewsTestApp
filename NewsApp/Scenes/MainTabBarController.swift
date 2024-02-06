//
//  MainTabBarController.swift
//  NewsApp
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInterface()
    }
}

// MARK: - Private methods

private extension MainTabBarController {

    func setupInterface() {
        tabBar.tintColor = .gray

        // MARK: - News tab item

        let newsVC = NewsViewController()

        let newsNC = UINavigationController(rootViewController: newsVC)
        newsNC.tabBarItem = UITabBarItem(.news)

        // MARK: - Favorites tab item

        let favoritesVC = FavoritesViewController()

        let favoritesNC = UINavigationController(rootViewController: favoritesVC)
        favoritesNC.tabBarItem = UITabBarItem(.favorites)

        // MARK: - Controllers

        viewControllers = [newsNC, favoritesNC]
    }

}

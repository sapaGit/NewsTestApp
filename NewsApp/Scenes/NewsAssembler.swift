//
//  NewsAssembler.swift
//  NewsApp
//

final class NewsAssembler {

    /// Assembly the components for the news screen.
    ///
    /// - Returns: An instance of `NewsViewController` configured with its associated presenter and router.
    class func assembly() -> NewsViewController {
        let view = NewsViewController()
        let networkManager = NetworkManager.shared
        let networkService = NewsService(netwokManager: networkManager)
        let router = NewsRouter(view: view)
        let presenter = NewsPresenter(
            view: view,
            networkService: networkService,
            router: router)

        view.presenter = presenter

        return view
    }
}

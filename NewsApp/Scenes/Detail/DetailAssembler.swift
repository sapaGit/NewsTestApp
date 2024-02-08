//
//  DetailAssembler.swift
//  NewsApp
//

final class DetailAssembler {

    /// Assembly the main components for the main screen.
    ///
    /// - Returns: An instance of `DetailViewController` configured with its associated presenter and router.
    class func assembly(model: News) -> DetailViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, model: model)

        view.presenter = presenter

        return view
    }
}

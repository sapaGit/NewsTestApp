//
//  BasePresenterProtocol.swift
//  NewsApp
//

import Foundation

protocol BasePresenterProtocol: AnyObject {
    /// Called when the view has loaded.
    func viewDidLoad()

    /// Called when the view is about to appear.
    func viewWillAppear()

    /// Called when the view has appeared.
    func viewDidAppear()

    /// Called when the view is about to disappear.
    func viewWillDisappear()
}

extension BasePresenterProtocol {
    func viewDidLoad() {}
    func viewWillAppear() {}
    func viewDidAppear() {}
    func viewWillDisappear() {}
}

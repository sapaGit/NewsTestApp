//
//  BaseViewProtocol.swift
//  NewsApp
//


import Foundation

protocol BaseViewProtocol: AnyObject {
    /// Show the navigation bar.
    func showNavigationBar()

    /// Hide the navigation bar.
    func hideNavigationBar()

    /// Show the tab bar.
    func showTabBar()

    /// Hide the tab bar.
    func hideTabBar()
}

extension BaseViewProtocol {
    func showNavigationBar() {}
    func hideNavigationBar() {}

    func showTabBar() {}
    func hideTabBar() {}
}

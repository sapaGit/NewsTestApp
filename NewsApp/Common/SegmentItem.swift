//
//  SegmentItem.swift
//  NewsApp
//


import Foundation

enum SegmentItem: CaseIterable {
    case recent
    case sport
    case food
    case technology

    var title: String {
        switch self {
        case .recent:
            return String.News.recent
        case .sport:
            return String.News.sport
        case .food:
            return String.News.food
        case .technology:
            return String.News.technology

        }
    }
}

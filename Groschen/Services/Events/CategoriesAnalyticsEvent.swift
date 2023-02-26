//
//  CategoriesAnalyticsEvent.swift
//  Groschen
//
//  Created by Yury Bogdanov on 04.09.2022.
//

import Foundation

enum CategoriesAnalyticsEvent: AnalyticsEventProtocol {
    case created(title: String)
    
    var name: String {
        switch self {
        case .created: return "CATEGORY_CREATED"
        }
    }
    
    var parameters: [AnyHashable : Any] {
        switch self {
        case .created(let title): return ["title": title]
        }
    }
}

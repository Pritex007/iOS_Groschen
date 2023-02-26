//
//  StatAnalyticsEvent.swift
//  Groschen
//
//  Created by Yury Bogdanov on 04.09.2022.
//

import Foundation

enum StatAnalyticsEvent: AnalyticsEventProtocol {
    case intervalChanged(type: String)
    
    var name: String {
        switch self {
        case .intervalChanged: return "STAT_INTERVAL_CHANGED"
        }
    }
    
    var parameters: [AnyHashable : Any] {
        switch self {
        case .intervalChanged(let type): return ["type": type]
        }
    }
}

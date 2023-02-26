//
//  ExpensesAnalticsEvent.swift
//  Groschen
//
//  Created by Yury Bogdanov on 04.09.2022.
//

import Foundation

enum ExpensesAnalticsEvent: AnalyticsEventProtocol {
    case creationTap
    case creationFinished(hasComment: Bool)
    
    var name: String {
        switch self {
        case .creationTap: return "EXPENSE_CREATION_TAP"
        case .creationFinished: return "EXPENSE_CREATION_FINISHED"
        }
    }
    
    var parameters: [AnyHashable : Any] {
        switch self {
        case .creationTap: return [:]
        case .creationFinished(let hasComment): return ["hasComment": hasComment]
        }
    }
}

//
//  SettingsAnalyticsEvent.swift
//  Groschen
//
//  Created by Yury Bogdanov on 04.09.2022.
//

import Foundation

enum SettingsAnalyticsEvent: AnalyticsEventProtocol {
    case sortTypeChanged(type: String)
    case userDataExported
    case userDataImported
    case currencyChanged(newCurrency: String)
    case pinCodeEnabled
    case pinCodeDisabled
    
    var name: String {
        switch self {
        case .sortTypeChanged: return "SORT_TYPE_CHANGED"
        case .userDataExported: return "USER_DATA_EXPORTED"
        case .userDataImported: return "USER_DATA_IMPORTED"
        case .currencyChanged: return "CURRENCY_CHANGED"
        case .pinCodeEnabled: return "PIN_CODE_ENABLED"
        case .pinCodeDisabled: return "PIN_CODE_DISABLED"
        }
    }
    
    var parameters: [AnyHashable : Any] {
        switch self {
        case .sortTypeChanged(let type): return ["type": type]
        case .userDataExported: return [:]
        case .userDataImported: return [:]
        case .currencyChanged(let newCurrency): return ["newCurrency": newCurrency]
        case .pinCodeEnabled: return [:]
        case .pinCodeDisabled: return [:]
        }
    }
}

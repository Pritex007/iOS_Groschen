//
//  AnalyticsEvent.swift
//  Groschen
//
//  Created by Yury Bogdanov on 04.09.2022.
//

import Foundation

protocol AnalyticsEventProtocol {
     var name: String { get }
     var parameters: [AnyHashable: Any] { get }
}

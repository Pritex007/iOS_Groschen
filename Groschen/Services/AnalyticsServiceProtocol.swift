//
//  AnalyticsServiceProtocol.swift
//  Groschen
//
//  Created by Yury Bogdanov on 04.09.2022.
//

import Foundation
import YandexMobileMetrica

 protocol AnalyticsConfiguratorProtocol {
     func activateAnalytics()
 }

 protocol AnalyticsServiceProtocol {
     func logEvent(_ event: AnalyticsEventProtocol)
 }

 final class AnalyticsService {

     // MARK: Private data structures
     
     private enum Constants {
         static let apiKey1 = "e6c4b46e-ce03-4a5d"
         static let apiKey2 = "-a59a-32e45db36135"
     }
 }


 // MARK: - AnalyticsConfiguratorProtocol

 extension AnalyticsService: AnalyticsConfiguratorProtocol {
     func activateAnalytics() {
         let key = Constants.apiKey1 + Constants.apiKey2
         guard let configuration = YMMYandexMetricaConfiguration(apiKey: key) else {
             assertionFailure("Failed to set up analytics!")
             return
         }
         YMMYandexMetrica.activate(with: configuration)
     }
 }


 // MARK: - AnalyticsServiceProtocol

 extension AnalyticsService: AnalyticsServiceProtocol {
     func logEvent(_ event: AnalyticsEventProtocol) {
         YMMYandexMetrica.reportEvent(event.name, parameters: event.parameters, onFailure: { error in
             assertionFailure("Did fail to send analytics: \(error)")
         })
     }
 }

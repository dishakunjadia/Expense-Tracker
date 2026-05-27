//
//  Currency.swift
//  ExpenseTracker
//
//  Created by Disha Kunjadia on 5/23/26.
//

import Foundation
struct Currency : Hashable{
    let name: String
    let code: String
    let symbol: String
}

extension Locale {
    func localizedCurrencySymbol(forCurrencyCode currencyCode: String) -> String? {
        guard let languageCode = language.languageCode?.identifier, let regionCode = region?.identifier else{ return nil }
        let components: [String: String] = [
            NSLocale.Key.languageCode.rawValue: languageCode,
            NSLocale.Key.countryCode.rawValue: regionCode,
            NSLocale.Key.currencyCode.rawValue: currencyCode
        ]
        
        let identifier = Locale.identifier(fromComponents: components)
        
        return Locale(identifier: identifier).currencySymbol
    }
    
}

extension Currency {
    static var currencyCodes: [String] = ["AED", "AFN", "ALL", "AUD", "YEN", "THB", "INR", "USD", "SGD", "NPR", "AED", "DHS", "JPY", "CAD"]
    
    static var allCurrencies : [Currency]{
        let currencies: [Currency] = currencyCodes.compactMap {
            let name = Locale.current.localizedString(forCurrencyCode: $0) ?? ""
            let symbol = Locale.current.localizedCurrencySymbol(forCurrencyCode: $0) ?? ""
            return Currency(name: name, code: $0, symbol: symbol)
        }
        return currencies
    }
}

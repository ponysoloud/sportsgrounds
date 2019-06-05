//
//  NumberFormatter+Extensions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

extension NumberFormatter {

    static var output: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return formatter
    }

    static func amount(minimumFractionDigits: Int, maximumFractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        if minimumFractionDigits > 0 {
            formatter.alwaysShowsDecimalSeparator = true
        }

        return formatter
    }

    static var amount: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 8

        return formatter
    }
}

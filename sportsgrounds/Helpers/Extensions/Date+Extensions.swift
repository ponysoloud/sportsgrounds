//
//  Date+Extensions.swift
//  wallet
//
//  Created by Alexander Ponomarev on 27/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

extension Date {
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    var age: Int {
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year ?? 0
    }
    
    var timeRecentFormatted: String {
        let dateFormatter = DateFormatter()
        let format = "HH:mm dd.MM"
        
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
    
    var recentFormatted: String {
        let dateFormatter = DateFormatter()
        let format = "dd.MM"
        
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
    
    var longFormatted: String {
        let dateFormatter = DateFormatter()
        let format = "d MMM yyyy"
        
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
    
    var fullFormatted: String {
        let dateFormatter = DateFormatter()
        let format = "MMM d, HH:mm"
        
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
}

extension Date {

    var time: String {
        let dateFormatter = DateFormatter()
        let format = "HH:mm"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var day: String {
        let dateFormatter = DateFormatter()
        let format = "dd"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var year: String {
        let dateFormatter = DateFormatter()
        let format = "yyyy"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    var timeZone: String {
        let dateFormatter = DateFormatter()
        let format = "ZZZZZ"

        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return "UTC \(dateFormatter.string(from: self))"
    }
}

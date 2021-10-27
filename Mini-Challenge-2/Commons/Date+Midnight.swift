//
//  Date+Midnight.swift
//  Mini-Challenge-2
//
//  Created by Iorgers Almeida on 27/10/21.
//

import Foundation

extension Date {
    func localString(dateStyle: DateFormatter.Style = .medium,
      timeStyle: DateFormatter.Style = .medium) -> String {
        return DateFormatter.localizedString(
          from: self,
          dateStyle: dateStyle,
          timeStyle: timeStyle)
    }

    var midnight: Date{
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: self)
    }
}

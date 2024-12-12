//
//  Extensions.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 10/11/24.
//

import Foundation
import UIKit

extension String {
    func localized() -> String {
        guard let path = Bundle.main.path(forResource: SettingsManager.shared.currentLanguage.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    static func formattedDateString(from dateString: String) -> String? {
        // DateFormatter để parse chuỗi ngày đầu vào
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd" // Định dạng của chuỗi ngày đầu vào
        inputFormatter.locale = Locale(identifier: "en") // Locale mặc định
        
        // Chuyển đổi chuỗi đầu vào thành kiểu Date
        if let date = inputFormatter.date(from: dateString) {
            // DateFormatter để format lại chuỗi ngày
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .long // Sử dụng kiểu "November 1, 2024"
            outputFormatter.timeStyle = .none
            outputFormatter.locale = Locale(identifier: SettingsManager.shared.currentLanguage.rawValue) // Sử dụng Locale theo ngôn ngữ
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
}

extension DateFormatter {
    
    static let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static func yearString(from dateString: String) -> String? {
        if let date = DateFormatter.yearFormatter.date(from: dateString) {
            let year = Calendar.current.component(.year, from: date)
            return "\(year)"
        }
        return nil
    }
    
}

extension UIView {
    
    func roundCorner(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        let borderPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let borderLayer = CAShapeLayer()
        borderLayer.path = borderPath.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
}

extension Int {
    func toRuntimeString() -> String {
        let hours = self / 60
        let minutes = self % 60
        return "\(hours)h \(minutes)m"
    }
    
    func toCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "$0"
    }
    
}

extension Array where Element == String {
    func toGenresString() -> String {
        return self.joined(separator: ", ")
    }
}

//
//  RequestToken.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 18/11/24.
//


import Foundation
import SwiftyJSON

struct RequestToken {
    
    //MARK: - Properties
    let token: String
    let expiresAt: Date
    func isValid() -> Bool {
        return Date() < expiresAt
    }
    
    //MARK: - Initialize
    init?(json: JSON) {
        guard
            let token = json["request_token"].string,
            let expiresAtString = json["expires_at"].string,
            let expiresAt = RequestToken.dateFormatter.date(from: expiresAtString)
        else {
            return nil
        }
        self.token = token
        self.expiresAt = expiresAt
    }
    
    /// DateFormatter tùy chỉnh cho định dạng trả về của API
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
}


//
//  HttpRequest.swift
//  Ministop
//
//  Created by NghienDamMinh on 24/10/24.
//

import Foundation


struct HttpRequest {
    
    //MARK: - Properties
    let url: String
    let method: String
    let headers: [String: String]?
    let body: [String: String]?
    var queryItems: [URLQueryItem]?
    
    //MARK: - Initialize
    func createRequest() -> Result<URLRequest> {
        guard var urlComponents = URLComponents(string: self.url) else {
            return .failure(.invalidURL)
        }
        var finalQueryItems = queryItems ?? []
        finalQueryItems.append(URLQueryItem(name: "language", value: SettingsManager.shared.currentLanguage == .english ? "en-US" : "vi-VN"))
        urlComponents.queryItems = finalQueryItems
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        if let body = body {
            if let bodyData = try? JSONSerialization.data(withJSONObject: body, options: []) {
                request.httpBody = bodyData
            } else {
                return .failure(.invalidBody)
            }
        }
        return .success(request)
    }
    
}

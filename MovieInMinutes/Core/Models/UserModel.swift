//
//  UserModel.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 17/11/24.
//

import RealmSwift
import SwiftyJSON
import Foundation

class UserModel: Object {
    // Attributes
    @Persisted var id: Int = 0
    @Persisted var languageCode: String = ""
    @Persisted var countryCode: String = ""
    @Persisted var name: String = ""
    @Persisted var includeAdult: Bool = false
    @Persisted var username: String = ""
    @Persisted var gravatarHash: String = ""
    @Persisted var tmdbAvatarPath: String = ""
    @Persisted var isGuest: Bool = false
    @Persisted var sessionID: String = ""
    
    override init() {
        super.init()
    }
    
    convenience init(isGuest: Bool) {
        self.init()
        self.isGuest = isGuest
    }
    
    // Initializer from JSON using SwiftyJSON
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.languageCode = json["iso_639_1"].stringValue
        self.countryCode = json["iso_3166_1"].stringValue
        self.name = json["name"].stringValue
        self.includeAdult = json["include_adult"].boolValue
        self.username = json["username"].stringValue
        // Extract gravatar hash
        self.gravatarHash = json["avatar"]["gravatar"]["hash"].stringValue
        // Extract tmdb avatar path
        self.tmdbAvatarPath = json["avatar"]["tmdb"]["avatar_path"].stringValue
        self.isGuest = false
    }
    
    static func createRequestToken(auth: String, completion: @escaping (Bool, String) -> Void) {
        // Đặt trạng thái loading
        AppConstant.isLoading = true
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/authentication/token/new",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "api_key", value: auth)
            ]
        )
        ApiServices.execute(request: request) { result in
            AppConstant.isLoading = false
            switch result {
            case .success(let json):
                if let token = RequestToken(json: json) {
                    AppConstant.requestToken = token
                    print(json)
                    completion(true, "")
                } else {
                    completion(false, "Không thể tạo token")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func createSessionId(requestToken: String, completion: @escaping (Bool, String, String) -> Void) {
        // Set loading state
        AppConstant.isLoading = true
        
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/authentication/session/new",
            method: "POST",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ],
            body: [
                "request_token": requestToken
            ],
            queryItems: [
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        ApiServices.execute(request: request) { result in
            AppConstant.isLoading = false
            switch result {
            case .success(let json):
                if let success = json["success"].bool,
                   let sessionID = json["session_id"].string,
                   success == true {
                    
                    print("session\(json)")
                    completion(true, sessionID, "")
                } else {
                    completion(true, "", "Failed to create session id")
                }
            case .failure(let error):
                completion(false, "", error.localizedDescription)
            }
        }
    }
    
    static func deleteSessionId(sessionId: String, completion: @escaping (Bool, String) -> Void) {
        // Set loading state
        AppConstant.isLoading = true
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/authentication/session",
            method: "DELETE",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json",
            ],
            body: [
                "session_id": sessionId
            ],
            queryItems: [
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        ApiServices.execute(request: request) { result in
            AppConstant.isLoading = false
            switch result {
            case .success(let json):
                if let success = json["success"].bool, success == true {
                    completion(true, "Session deleted successfully")
                } else {
                    completion(false, "Fail to delete sessionID")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func fetchAccountDetail(sessionID: String, completion: @escaping (Bool, String) -> Void) {
        // Set loading state
        AppConstant.isLoading = true
        let request = HttpRequest(
            url:"https://api.themoviedb.org/3/account",
            method: "GET",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey),
                URLQueryItem(name: "session_id", value: sessionID),
            ]
        )
        
        ApiServices.execute(request: request) { result in
            AppConstant.isLoading = false
            switch result {
            case .success(let json):
                let user = UserModel(json: json)
                user.sessionID = sessionID
                DispatchQueue.main.async {
                    RealmManager.shared.currentUser = user
                    RealmManager.shared.saveSessionId(sessionID)
                }
                completion(true, "")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
}

//
//  MyList.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//


import Foundation
import SwiftyJSON

class MyCollectionModel {
    
    //MARK: - Properties
    var page: Int = 0
    var results: [MyListModel] = []
    var totalPages: Int = 0
    var totalResults: Int = 0
    
    //MARK: - Initialize
    init() {}
    
    convenience init(json: JSON) {
        self.init()
        self.page = json["page"].intValue
        self.totalPages = json["total_pages"].intValue
        self.totalResults = json["total_results"].intValue
        
        // Parse từng list trong "results"
        self.results = json["results"].arrayValue.map { MyListModel(json: $0) }
    }
}


// MARK: - API methods
extension MyCollectionModel {
    
    static func fetchMyCollection(accountID: Int, sessionID: String, completion: @escaping (Bool, MyCollectionModel, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/account/\(accountID)/lists",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                // Parse the array of lists
                let collection = MyCollectionModel(json: json)
                completion(true, collection, "")
            case .failure(let error):
                completion(false, MyCollectionModel(), error.localizedDescription)
            }
        }
    }
    
}

//
//  YouTubeResultType.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 15/11/24.
//

import Foundation
import SwiftyJSON

class YoutubeVideoModel {
    
    //MARK: - Properties
    var title: String
    var viewCount: Int
    var likeCount: Int
    var videoID: String = ""
    // MARK: - Initializer
    init(title: String, viewCount: Int, likeCount: Int) {
        self.title = title
        self.viewCount = viewCount
        self.likeCount = likeCount
    }
    
    convenience init?(json: JSON) {
        guard
            let title = json["snippet"]["title"].string,
            let viewCountString = json["statistics"]["viewCount"].string,
            let viewCount = Int(viewCountString),
            let likeCountString = json["statistics"]["likeCount"].string,
            let likeCount = Int(likeCountString)
        else {
            return nil
        }
        self.init(title: title, viewCount: viewCount, likeCount: likeCount)
    }
    
    // MARK: - Fetch Video
    static func fetchYouTubeVideoIds(keyword: String, apiKey: String, completion: @escaping (Bool, [String], String) -> Void) {
        // Kiểm tra xem có đang hiển thị loading indicator hay không
        if !AppConstant.isLoading {
            LoadingManager.shared.showLoadingIndicator()
            AppConstant.isLoading = true
        }
        
        // Define URL and parameters
        let url = "https://www.googleapis.com/youtube/v3/search"
        let queryItems = [
            URLQueryItem(name: "part", value: "id"),
            URLQueryItem(name: "q", value: keyword),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "regionCode", value: SettingsManager.shared.currentLanguage == .english ? "GB" : "VN"),
            URLQueryItem(name: "maxResults", value: "5"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        // Create URL Request
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = queryItems
        
        guard let requestUrl = urlComponents?.url else {
            // Ẩn loading indicator nếu có lỗi và trả về
            if AppConstant.isLoading {
                LoadingManager.shared.hideLoadingIndicator()
                AppConstant.isLoading = false
            }
            completion(false, [], "Invalid URL")
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Ẩn loading indicator khi yêu cầu hoàn tất
            defer {
                if AppConstant.isLoading {
                    LoadingManager.shared.hideLoadingIndicator()
                    AppConstant.isLoading = false
                }
            }
            
            if let error = error {
                completion(false, [], error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(false, [], "No data received")
                return
            }
            
            do {
                // Parse JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    // Extract videoId from each item
                    let videoIds = items.compactMap { item -> String? in
                        if let id = item["id"] as? [String: Any],
                           let videoId = id["videoId"] as? String {
                            return videoId
                        }
                        return nil
                    }
                    if videoIds.isEmpty {
                        completion(false, [], "No video IDs found")
                    } else {
                        completion(true, videoIds, "")
                    }
                } else {
                    completion(false, [], "Failed to parse items array")
                }
            } catch {
                completion(false, [], error.localizedDescription)
            }
        }
        task.resume()
    }
    
    static func fetchYouTubeVideoDetails(videoId: String, apiKey: String, completion: @escaping (Bool, YoutubeVideoModel?, String) -> Void) {
        // Kiểm tra xem có đang hiển thị loading indicator hay không
        if !AppConstant.isLoading {
            LoadingManager.shared.showLoadingIndicator()
            AppConstant.isLoading = true
        }
        
        // Define URL and parameters
        let url = "https://www.googleapis.com/youtube/v3/videos"
        let queryItems = [
            URLQueryItem(name: "part", value: "snippet,statistics"),
            URLQueryItem(name: "id", value: videoId),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        // Create URL Request
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = queryItems
        
        guard let requestUrl = urlComponents?.url else {
            // Ẩn loading indicator nếu có lỗi và trả về
            if AppConstant.isLoading {
                LoadingManager.shared.hideLoadingIndicator()
                AppConstant.isLoading = false
            }
            completion(false, nil, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Execute the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Ẩn loading indicator khi yêu cầu hoàn tất
            defer {
                if AppConstant.isLoading {
                    LoadingManager.shared.hideLoadingIndicator()
                    AppConstant.isLoading = false
                }
            }
            
            if let error = error {
                completion(false, nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(false, nil, "No data received")
                return
            }
            
            do {
                let json = try JSON(data: data)
                if let item = json["items"].array?.first {
                    if let video = YoutubeVideoModel(json: item) {
                        video.videoID = videoId
                        completion(true, video, "")
                    } else {
                        completion(false, nil, "Failed to parse video details")
                    }
                } else {
                    completion(false, nil, "No video items found")
                }
            } catch {
                completion(false, nil, error.localizedDescription)
            }
        }
        task.resume()
    }
}

import Foundation
import SwiftyJSON

class MovieModel {
    
    //MARK: - Properties
    var backdropPath: String = ""
    var id: Int = 0
    var genreIDs: [Int] = []
    var genres: [String] = [] // Thêm danh sách thể loại dạng chuỗi
    var overview: String = ""
    var posterPath: String = ""
    var releaseDate: String = ""
    var title: String = ""
    var voteAverage: Double = 0
    var voteCount: Int = 0
    var rating: Double = 0
    var status: String = "" // Trạng thái phát hành
    var runtime: Int = 0 // Thời gian phim
    var originalLanguage: String = "" // Ngôn ngữ gốc
    var budget: Int = 0 // Ngân sách
    var revenue: Int = 0 // Doanh thu
    var isAdult: Bool = false // Lưu trạng thái 'adult'
    var originalTitle: String = ""
    
    //MARK: - Initializers
    init() {}
    
    convenience init(json: JSON) {
        self.init()
        self.isAdult = json["adult"].boolValue
        self.backdropPath = json["backdrop_path"].stringValue
        self.id = json["id"].intValue
        self.overview = json["overview"].stringValue
        self.posterPath = json["poster_path"].stringValue
        self.releaseDate = json["release_date"].stringValue
        self.title = json["title"].stringValue
        self.voteAverage = json["vote_average"].doubleValue
        self.voteCount = json["vote_count"].intValue
        self.genreIDs = json["genre_ids"].arrayValue.map { $0.intValue }
        self.genres = json["genres"].arrayValue.map { $0["name"].stringValue } // Lấy danh sách tên thể loại
        self.rating = json["rating"].doubleValue
        self.status = json["status"].stringValue // Trạng thái phát hành
        self.runtime = json["runtime"].intValue // Thời gian phim
        self.originalLanguage = json["original_language"].stringValue // Ngôn ngữ gốc
        self.budget = json["budget"].intValue // Ngân sách
        self.revenue = json["revenue"].intValue // Doanh thu
        self.originalTitle = json["original_title"].stringValue
    }
}

//MARK: - API Methods
extension MovieModel {
    
    static func fetchMovieList( type: MovieListType, completion: @escaping (Bool, [MovieModel], String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/movie/\(type.rawValue)",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let movieList = json["results"].arrayValue.map { MovieModel(json: $0) }
                completion(true, movieList, "")
            case .failure(let error):
                completion(false, [], error.localizedDescription)
            }
        }
    }
    
    static func fetchMovieDetail(id: Int, completion: @escaping (Bool, MovieModel, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/movie/\(id)",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let movie = MovieModel(json: json)
                completion(true, movie, "")
            case .failure(let error):
                completion(false, MovieModel(), error.localizedDescription)
            }
        }
    }
    
    static func fetchOfficialTrailer(category: Category, id: Int, completion: @escaping (Bool, String, String) -> Void) {
        // Bắt đầu hiển thị loading
        if !AppConstant.isLoading {
            LoadingManager.shared.showLoadingIndicator()
            AppConstant.isLoading = true
        }
        
        // Xây dựng URL và các query parameters
        let baseURL = "https://api.themoviedb.org/3/\(category.rawValue)/\(id)/videos"
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
        ]
        
        guard let requestUrl = urlComponents?.url else {
            // Ẩn loading nếu có lỗi URL
            if AppConstant.isLoading {
                LoadingManager.shared.hideLoadingIndicator()
                AppConstant.isLoading = false
            }
            completion(false, "", "Invalid URL")
            return
        }
        
        // Tạo URLRequest
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Thực hiện yêu cầu
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Ẩn loading khi hoàn thành yêu cầu
            DispatchQueue.main.async {
                if AppConstant.isLoading {
                    LoadingManager.shared.hideLoadingIndicator()
                    AppConstant.isLoading = false
                }
            }
            
            if let error = error {
                completion(false, "", "Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(false, "", "No data received")
                return
            }
            
            do {
                let json = try JSON(data: data)
                // Lọc kết quả
                if let trailer = json["results"].arrayValue.first(where: { video in
                    video["name"].stringValue == "Official Trailer" && video["site"].stringValue == "YouTube"
                }) {
                    let key = trailer["key"].stringValue
                    completion(true, key, "")
                } else {
                    completion(true, "", "No official trailer found")
                }
            } catch {
                completion(false, "", "Failed to parse JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    static func fetchTrendingMovie(completion: @escaping (Bool, [MovieModel], String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/trending/movie/day",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                let movieList = json["results"].arrayValue.map { MovieModel(json: $0) }
                completion(true, movieList, "")
            case .failure(let error):
                completion(false, [], error.localizedDescription)
            }
        }
    }
    
    static func ratingMovie(movieID: Int, score: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/movie/\(movieID)/rating",
            method: "POST",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json;charset=utf-8",
            ],
            body: [
                "value": "\(score * 2)"
            ],
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                print(json["status_message"])
                completion(true, "")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func fetchRatedMovie(accountID: Int, sessionID: String, completion: @escaping (Bool, [MovieModel], String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/account/\(accountID)/rated/movies",
            method: "GET",
            headers: [
                "Accept": "application/json",
            ],
            body: nil,
            queryItems: [
                URLQueryItem(name: "session_id", value: sessionID),
                URLQueryItem(name: "sort_by", value: "created_at.asc"),
                URLQueryItem(name: "api_key", value: ScriptConstants.ApiKey)
            ]
        )
        ApiServices.execute(request: request) { result in
            switch result {
            case .success(let json):
                let json = JSON(json)
                for movie in json["results"].arrayValue {
                    let id = movie["id"].intValue
                    let rating = movie["rating"].doubleValue
                    AppConstant.moviesRated[id] = rating
                }
                let movieList = json["results"].arrayValue.map { MovieModel(json: $0) }
                completion(true,movieList, "")
            case .failure(let error):
                completion(false,[], error.localizedDescription)
            }
        }
    }
    
    static func deleteRatingMovie(movieID: Int, sessionID: String, completion: @escaping (Bool, String) -> Void) {
        let request = HttpRequest(
            url: "https://api.themoviedb.org/3/movie/\(movieID)/rating",
            method: "DELETE",
            headers: [
                "Accept": "application/json",
                "Content-Type": "application/json;charset=utf-8",
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
                print(json["status_message"])
                completion(true, "")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
}

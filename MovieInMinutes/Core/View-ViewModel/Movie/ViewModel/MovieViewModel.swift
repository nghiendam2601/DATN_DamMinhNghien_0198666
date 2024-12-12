import Foundation

class MovieViewModel {
    
    //MARK: - Properties
    var nowPlaying: [MovieModel] = []
    var popular: [MovieModel] = []
    var topRated: [MovieModel] = []
    var upcoming: [MovieModel] = []
    var trending: [MovieModel] = []
    var onLoadMovieLists: (([MovieModel], [MovieModel], [MovieModel], [MovieModel], [MovieModel]) -> Void)?
    var onShowAlert: ((String) -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func fetchMovieList(accountID: Int, sessionID: String) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            MovieModel.fetchTrendingMovie { (result, movie, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.trending = movie
                } else {
                    weakSelf.onShowAlert?(message)  // Show alert if error
                    dispatchGroup.leave()  // Ensure leaving the group even in error case
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch Now Playing Movies
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            MovieModel.fetchMovieList(type: .NowPlaying) { (result, movieList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.nowPlaying = movieList
                } else {
                    weakSelf.onShowAlert?(message)  // Show alert if error
                    dispatchGroup.leave()  // Ensure leaving the group even in error case
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch Popular Movies
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            MovieModel.fetchMovieList(type: .Popular) { (result, movieList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.popular = movieList
                } else {
                    weakSelf.onShowAlert?(message)  // Show alert if error
                    dispatchGroup.leave()
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch Top Rated Movies
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            MovieModel.fetchMovieList(type: .TopRated) { (result, movieList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.topRated = movieList
                } else {
                    weakSelf.onShowAlert?(message)  // Show alert if error
                    dispatchGroup.leave()
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch Upcoming Movies
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            MovieModel.fetchMovieList(type: .Upcoming) { (result, movieList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.upcoming = movieList
                } else {
                    weakSelf.onShowAlert?(message)  // Show alert if error
                    dispatchGroup.leave()
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        
        if !sessionID.isEmpty {
            dispatchGroup.enter()
            DispatchQueue.global().async { [weak self] in
                MovieModel.fetchRatedMovie(accountID: accountID, sessionID: sessionID ) { [weak self] result,_, message in
                    guard let weakSelf = self else { return }
                    if result {} else {
                        weakSelf.onShowAlert?(message)
                        dispatchGroup.leave()
                        return
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        // Notify when all requests are complete
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.onLoadMovieLists?(nowPlaying, popular, topRated, upcoming, trending)            
        }
    }
    
    func numberOfMovieList(_ movieListType: MovieListType) -> Int {
        switch movieListType {
        case .NowPlaying:
            return nowPlaying.count
        case .Popular:
            return popular.count
        case .TopRated:
            return topRated.count
        case .Upcoming:
            return upcoming.count
        }
    }
    
    func getMovieList(_ movieListType: MovieListType) -> [MovieModel]? {
        switch movieListType {
        case .NowPlaying:
            return nowPlaying
        case .Popular:
            return popular
        case .Upcoming:
            return upcoming
        case .TopRated:
            return topRated
        }
    }
    
}

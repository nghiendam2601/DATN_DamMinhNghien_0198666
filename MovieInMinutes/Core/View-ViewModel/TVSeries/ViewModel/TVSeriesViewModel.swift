import Foundation

class TVSeriesViewModel {
    
    //MARK: - Properties
    var airingToday: [TVSeriesModel]?
    var popular: [TVSeriesModel]?
    var onTheAir: [TVSeriesModel]?
    var topRated: [TVSeriesModel]?
    var trending: [TVSeriesModel]?
    var onLoadTVSeriesLists: (([TVSeriesModel], [TVSeriesModel], [TVSeriesModel], [TVSeriesModel]) -> Void)?
    var onShowAlert: ((String) -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func fetchTVSeriesList(accountID: Int, sessionID: String) {
        let dispatchGroup = DispatchGroup()
        
        if !sessionID.isEmpty {
            dispatchGroup.enter()
            DispatchQueue.global().async { [weak self] in
                TVSeriesModel.fetchRatedTV(accountID: accountID, sessionID: sessionID ) { [weak self] result,_, message in
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
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            TVSeriesModel.fetchTrendingTVSeries { (result, tvSeriesList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.trending = tvSeriesList
                } else {
                    weakSelf.onShowAlert?(message)  // Show alert if error
                    dispatchGroup.leave()  // Ensure leaving the group even in error case
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch Airing Today TV Series
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            TVSeriesModel.fetchTVSeriesList(auth: ScriptConstants.ApiKey, type: .AiringToday) { (result, tvSeriesList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.airingToday = tvSeriesList
                } else {
                    weakSelf.onShowAlert?(message)  // Show alert if error
                    dispatchGroup.leave()
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch Popular TV Series
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            TVSeriesModel.fetchTVSeriesList(auth: ScriptConstants.ApiKey, type: .Popular) { (result, tvSeriesList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.popular = tvSeriesList
                } else {
                    weakSelf.onShowAlert?(message)
                    dispatchGroup.leave()
                    return
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch On The Air TV Series
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            TVSeriesModel.fetchTVSeriesList(auth: ScriptConstants.ApiKey, type: .OnTheAir) { (result, tvSeriesList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.onTheAir = tvSeriesList
                } else {
                    weakSelf.onShowAlert?(message)
                    dispatchGroup.leave()
                    return
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch Top Rated TV Series
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            TVSeriesModel.fetchTVSeriesList(auth: ScriptConstants.ApiKey, type: .TopRated) { (result, tvSeriesList, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.topRated = tvSeriesList
                } else {
                    weakSelf.onShowAlert?(message)
                    dispatchGroup.leave()
                    return
                }
                dispatchGroup.leave()
            }
        }
        
        // Notify when all requests are complete
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            if let airingToday = self.airingToday,
               let popular = self.popular,
               let onTheAir = self.onTheAir,
               let topRated = self.topRated {
                self.onLoadTVSeriesLists?(airingToday, popular, onTheAir, topRated)
            }
        }
    }
    
    func numberOfTVSeriesList(_ tvSeriesListType: TVSeriesListType) -> Int {
        switch tvSeriesListType {
        case .AiringToday:
            return airingToday?.count ?? 0
        case .Popular:
            return popular?.count ?? 0
        case .OnTheAir:
            return onTheAir?.count ?? 0
        case .TopRated:
            return topRated?.count ?? 0
        }
    }
    
    func getTVSeriesList(_ tvSeriesListType: TVSeriesListType) -> [TVSeriesModel]? {
        switch tvSeriesListType {
        case .AiringToday:
            return airingToday
        case .Popular:
            return popular
        case .OnTheAir:
            return onTheAir
        case .TopRated:
            return topRated
        }
    }
    
}

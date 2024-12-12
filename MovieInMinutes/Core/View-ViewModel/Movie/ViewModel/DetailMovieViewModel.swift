//
//  File.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 10/11/24.
//

import Foundation

class DetailMovieViewModel {
    
    //MARK: - Properties
    var cast: [ActorModel]?
    var key: String?
    var movie: MovieModel?
    var onShowAlert: ((String) -> Void)?
    var onfetchSucceed: (() -> Void)?
    var onRatingSuccess: (() -> Void)?
    var onDeleteRatingSuccess: (() -> Void)?
    var onAdd: ((String) -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func deleteRatingMovie(id: Int) {
        guard let sessionID = RealmManager.shared.currentUser?.sessionID else { return }
        MovieModel.deleteRatingMovie(movieID: id, sessionID: sessionID) { [weak self] result, message in
            guard let weakSelf = self else { return }
            if result {
                AppConstant.moviesRated.removeValue(forKey: id)
                weakSelf.onDeleteRatingSuccess?()
            } else {
                weakSelf.onShowAlert?(message)
            }
        }
    }
    
    func fetchMovieData(id: Int) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            MovieModel.fetchMovieDetail(id: id) { (result, movie, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.movie = movie
                } else {
                    weakSelf.onShowAlert?(message)
                    dispatchGroup.leave()  // Ensure leaving the group even in error case
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        // Fetch Cast
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            ActorModel.fetchCast(category: .Movie, Auth: ScriptConstants.ApiKey, id: id) { (result, cast, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.cast = cast
                } else {
                    weakSelf.onShowAlert?(message)
                    dispatchGroup.leave()  // Ensure leaving the group even in error case
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        // Fetch Official Trailer
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            MovieModel.fetchOfficialTrailer(category: .Movie, id: id) { (result, key, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.key = key
                    print("key \(key)")
                } else {
                    weakSelf.onShowAlert?(message)
                    dispatchGroup.leave()  // Ensure leaving the group even in error case
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        // Notify when all requests are complete
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.onfetchSucceed?()
        }
    }
    
    func ratingMovie(movieID: Int, score: Int) {
        guard let sessionID = RealmManager.shared.currentUser?.sessionID else { return }
        
        DispatchQueue.global().async { [weak self] in
            MovieModel.ratingMovie(movieID: movieID, score: score, sessionID: sessionID) { [weak self] result, message in
                guard let weakSelf = self else { return }
                
                DispatchQueue.main.async {
                    if result {
                        AppConstant.moviesRated[movieID] = Double(score * 2)
                        weakSelf.onRatingSuccess?()
                    } else {
                        weakSelf.onShowAlert?(message)
                    }
                }
            }
        }
    }
    
    func addList(listID: Int, movieID: Int) {
        guard let sessionID = RealmManager.shared.currentUser?.sessionID else { return }
        
        DispatchQueue.global().async { [weak self] in
            MyListModel.checkItemStatus(listID: listID, movieID: movieID, sessionID: sessionID) { [weak self] result, message in
                guard let weakSelf = self else { return }
                
                if result {
                    MyListModel.addMovieToList(listID: listID, movieID: movieID, sessionID: sessionID) { [weak self] result, message in
                        guard let weakSelf = self else { return }
                        
                        DispatchQueue.main.async {
                            if result {
                                weakSelf.onAdd?(LanguageDictionary.addSuccess.dictionary)
                            } else {
                                weakSelf.onShowAlert?(message)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        weakSelf.onAdd?(LanguageDictionary.movieAlreadyAdded.dictionary)
                    }
                }
            }
        }
    }
    
}

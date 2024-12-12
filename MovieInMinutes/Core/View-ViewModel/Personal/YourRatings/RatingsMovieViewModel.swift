//
//  RatingsMovieViewModel.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 25/11/24.
//

import Foundation

class RatingsMovieViewModel {
    
    //MARK: - Properties
    var movies: [MovieModel]?
    var onShowAlert: ((String) -> Void)?
    var onFetchRatedMovies: (() -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func fetchRatedMovies() {
        guard let user = RealmManager.shared.currentUser else { return }
        let accountID = user.id
        let sessionID = user.sessionID
        DispatchQueue.global().async { [weak self] in
            MovieModel.fetchRatedMovie(accountID: accountID, sessionID: sessionID) { [weak self] result, movieList, message in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.movies = movieList
                    weakSelf.onFetchRatedMovies?()
                } else {
                    weakSelf.onShowAlert?(message)
                    return
                }
            }
        }
    }
    
}

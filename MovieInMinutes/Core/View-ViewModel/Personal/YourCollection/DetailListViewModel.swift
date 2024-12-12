//
//  DetailListViewModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//

import Foundation

class DetailListViewModel{
    
    //MARK: - Properties
    var movies: [MovieModel]?
    var onShowAlert: ((String) -> Void)?
    var onFetchDetailListSuccess: (() -> Void)?
    var onClearSuccess: (() -> Void)?
    var onRemoveMovieSuccess: (() -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func fetchDetaiList(listID: Int) {
        guard let user = RealmManager.shared.currentUser else { return }
        let sessionID = user.sessionID
        DispatchQueue.global().async { [weak self] in
            MyListModel.fetchDetailList(listID: listID, sessionID: sessionID) { [weak self] result, movies, message in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.movies = movies
                    weakSelf.onFetchDetailListSuccess?()
                } else {
                    weakSelf.onShowAlert?(message)
                }
            }
        }
    }
    
    func clearList(listID: Int) {
        guard let user = RealmManager.shared.currentUser else { return }
        let sessionID = user.sessionID
        DispatchQueue.global().async { [weak self] in
            MyListModel.clearList(listID: listID, sessionID: sessionID) { [weak self] result, message in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.onClearSuccess?()
                } else {
                    weakSelf.onShowAlert?(message)
                }
            }
        }
    }
    
    func removeMovieFromList(listID: Int, movieID: Int) {
        guard let user = RealmManager.shared.currentUser else { return }
        let sessionID = user.sessionID
        DispatchQueue.global().async { [weak self] in
            MyListModel.removeMovieFromList(listID: listID, movieID: movieID, sessionID: sessionID) { [weak self] result, message in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.onRemoveMovieSuccess?()
                } else {
                    weakSelf.onShowAlert?(message)
                }
            }
        }
    }
    
}

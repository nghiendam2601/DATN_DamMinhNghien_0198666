//
//  SearchViewModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 15/11/24.
//

import Foundation

class SearchViewModel {
    
    //MARK: - Properties
    var searchResultArray: [(Any, String)]?
    var onSearchCompleted: (() -> Void)?
    var onSearchFailed: ((String) -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func searchMulti(query: String) {
        // Thực hiện gọi API
        TheMovieDBModel.searchMulti(Auth: ScriptConstants.ApiKey, query: query) { [weak self] isSuccessed, resultArray, message in
            guard let weakSelf = self else { return }
            if isSuccessed {
                weakSelf.searchResultArray = resultArray
                weakSelf.onSearchCompleted?()
            } else {
                weakSelf.onSearchFailed?( message)
            }
        }
    }
    
}

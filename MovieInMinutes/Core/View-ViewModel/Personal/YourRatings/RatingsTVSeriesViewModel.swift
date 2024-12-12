//
//  RatingsMovieViewModel.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 25/11/24.
//

import Foundation

class RatingsTVSeriesViewModel {
    
    //MARK: - Properties
    var listTVSeries: [TVSeriesModel]?
    var onShowAlert: ((String) -> Void)?
    var onFetchRatedListTVSeries: (() -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func fetchRatedListTVSeries() {
        guard let user = RealmManager.shared.currentUser else { return }
        let accountID = user.id
        let sessionID = user.sessionID
        DispatchQueue.global().async { [weak self] in
            TVSeriesModel.fetchRatedTV(accountID: accountID, sessionID: sessionID) { [weak self] result, listTVSeries, message in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.listTVSeries = listTVSeries
                    weakSelf.onFetchRatedListTVSeries?()
                } else {
                    weakSelf.onShowAlert?(message)
                    return
                }
            }
        }
    }
    
}

//
//  DetailSeasonViewModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 29/11/24.
//

import Foundation

class DetailSeasonViewModel {
    
    //MARK: - Properties
    var season: DetailSeasonModel?
    var onFetchDetailSeasonDataFailed: ((String) -> Void)?
    var onFetchDetailSeasonSuccess: (() -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func fetchDetailSeasonData(tvSeriesID: Int, seasonNumber: Int) {
        DispatchQueue.global().async { [weak self] in
            DetailSeasonModel.fetchSeasonDetail(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber) { [weak self] result, season, message in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.season = season
                    weakSelf.onFetchDetailSeasonSuccess?()
                } else {
                    weakSelf.onFetchDetailSeasonDataFailed?(message)
                }
            }
        }
    }
    
}

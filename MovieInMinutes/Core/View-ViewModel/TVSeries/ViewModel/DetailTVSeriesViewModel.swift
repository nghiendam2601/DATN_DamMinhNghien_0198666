//
//  File.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 10/11/24.
//

import Foundation

class DetailTVSeriesViewModel {
    
    //MARK: - Properties
    var cast: [ActorModel]?
    var key: String?
    var tvSeries: TVSeriesModel?
    var onShowAlert: ((String) -> Void)?
    var onfetchSucceed: (() -> Void)?
    var onRatingSuccess: (() -> Void)?
    var onDeleteRatingSuccess: (() -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func deleteRatingTVSeries(id: Int) {
        guard let sessionID = RealmManager.shared.currentUser?.sessionID else { return }
        TVSeriesModel.deleteRatingTVSeries(tvSeriesID: id, sessionID: sessionID) { [weak self] result, message in
            guard let weakSelf = self else { return }
            if result {
                AppConstant.tvRated.removeValue(forKey: id)
                weakSelf.onDeleteRatingSuccess?()
            } else {
                weakSelf.onShowAlert?(message)
            }
        }
    }
    
    func fetchTVSeriesData(id: Int) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            TVSeriesModel.fetchTVSeriesDetail(id: id) { (result, tv, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.tvSeries = tv
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
            ActorModel.fetchCast(category: .TVSeries, Auth: ScriptConstants.ApiKey, id: id) { (result, cast, message) in
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
            MovieModel.fetchOfficialTrailer(category: .TVSeries, id: id) { (result, key, message) in
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
    
    func ratingTVSeries(tvSeriesID: Int, score: Int) {
        guard let sessionID = RealmManager.shared.currentUser?.sessionID else { return }
        
        DispatchQueue.global().async { [weak self] in
            TVSeriesModel.ratingTVSeries(tvSeriesID: tvSeriesID, score: score, sessionID: sessionID) { [weak self] result, message in
                guard let weakSelf = self else { return }
                
                DispatchQueue.main.async {
                    if result {
                        AppConstant.tvRated[tvSeriesID] = Double(score * 2)
                        weakSelf.onRatingSuccess?()
                    } else {
                        weakSelf.onShowAlert?(message)
                    }
                }
            }
        }
    }
    
}

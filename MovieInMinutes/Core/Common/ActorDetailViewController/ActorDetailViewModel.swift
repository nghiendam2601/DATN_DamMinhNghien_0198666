//
//  ActorDetailViewModel.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 27/11/24.
//

import Foundation

class ActorDetailViewModel {
    
    //MARK: - Properties
    var actor: ActorModel?
    var onShowAlert: ((String) -> Void)?
    var onFetchSucceed: (() -> Void)?
    
    //MARK: - Methods
    func fetchMovieList(id: Int) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            ActorModel.fetchDetailActor(id: id) { (result, actor, message) in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.actor = actor
                } else {
                    weakSelf.onShowAlert?(message)  // Show alert if error
                    dispatchGroup.leave()  // Ensure leaving the group even in error case
                    return  // Return early to prevent other API calls
                }
                dispatchGroup.leave()
            }
        }
        
        // Notify when all requests are complete
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.onFetchSucceed?()
        }
    }
}

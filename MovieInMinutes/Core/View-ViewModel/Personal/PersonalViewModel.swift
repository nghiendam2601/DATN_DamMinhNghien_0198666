//
//  PersonalViewModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 19/11/24.
//

import Foundation

class PersonalViewModel {
    
    //MARK: - Properties
    var onCreateRequestTokenSuccessed: ((String) -> Void)?
    var onLoginSuccessed: (() -> Void)?
    var onFailed: ((String) -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func createRequestToken() {
        UserModel.createRequestToken(auth: ScriptConstants.ApiKey) { [weak self] result, message in
            guard let weakSelf = self else { return }
            if result {
                if let requestToken = AppConstant.requestToken,
                   requestToken.isValid() {
                    weakSelf.onCreateRequestTokenSuccessed?(requestToken.token)
                }
            } else {
                weakSelf.onFailed?(message)
            }
        }
    }
    
    func logout() {
        guard let user = RealmManager.shared.currentUser else { return }
        UserModel.deleteSessionId(sessionId: user.sessionID) { [weak self] result, message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if result {
                    RealmManager.shared.deleteCurrentUser()
                    weakSelf.onLoginSuccessed?()
                } else {
                    weakSelf.onFailed?(message)
                }
            }
        }
    }
    
}

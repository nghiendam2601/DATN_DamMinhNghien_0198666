//
//  YourCollectionViewModel.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//

import Foundation

class YourCollectionViewModel {
    
    //MARK: - Properties
    var collection: MyCollectionModel?
    var onShowAlert: ((String) -> Void)?
    var onFetchCollectionSuccess: (() -> Void)?
    var onDeleteListSuccess: (() -> Void)?
    var onCreateSuccess: (() -> Void)?
    
    //MARK: - Initialize
    init() {}
    
    //MARK: - Methods
    func fetchMyCollection() {
        DispatchQueue.main.async {
            guard let user = RealmManager.shared.currentUser else { return }
            let accountID = user.id
            let sessionID = user.sessionID
            DispatchQueue.global().async { [weak self] in
                MyCollectionModel.fetchMyCollection(accountID: accountID, sessionID: sessionID) { [weak self] result, collection, message in
                    guard let weakSelf = self else { return }
                    if result {
                        weakSelf.collection = collection
                        weakSelf.onFetchCollectionSuccess?()
                    } else {
                        weakSelf.onShowAlert?(message)
                    }
                }
            }
        }
    }
    
    func deleteList(listID: Int) {
        guard let user = RealmManager.shared.currentUser else { return }
        let sessionID = user.sessionID
        DispatchQueue.global().async { [weak self] in
            MyListModel.deleteList(listID: listID, sessionID: sessionID) { [weak self] result, message in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.onDeleteListSuccess?()
                } else {
                    weakSelf.onShowAlert?(message)
                }
            }
        }
    }
    
    func createList(name: String, des: String) {
        guard let user = RealmManager.shared.currentUser else { return }
        let sessionID = user.sessionID
        DispatchQueue.global().async { [weak self] in
            MyListModel.createList(name: name, des: des, sessionID: sessionID) { [weak self] result, message in
                guard let weakSelf = self else { return }
                if result {
                    weakSelf.onCreateSuccess?()
                } else {
                    weakSelf.onShowAlert?(message)
                }
            }
        }
    }
    
}

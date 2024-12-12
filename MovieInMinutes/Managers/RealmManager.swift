//
//  RealmManager.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 17/11/24.
//


import RealmSwift

class RealmManager {
    
    //MARK: - Properties
    static let shared = RealmManager() // Singleton
    private var realm: Realm
    private var user: UserModel? // Quản lý người dùng hiện tại trong bộ nhớ
    
    private init() {
        realm = try! Realm()
        user = loadCurrentUserFromRealm()
    }
    
    // MARK: - Lấy User hiện tại
    var currentUser: UserModel? {
        get { user }
        set {
            guard let newUser = newValue else { return }
            saveUserToRealm(newUser) // Cập nhật User vào Realm
            user = newUser
        }
    }
    
    // MARK: - Thêm hoặc cập nhật User vào Realm (chỉ cập nhật user đầu tiên)
    private func saveUserToRealm(_ user: UserModel) {
        try? realm.write {
            if let existingUser = realm.objects(UserModel.self).first {
                existingUser.id = user.id
                existingUser.languageCode = user.languageCode
                existingUser.countryCode = user.countryCode
                existingUser.name = user.name
                existingUser.includeAdult = user.includeAdult
                existingUser.username = user.username
                existingUser.gravatarHash = user.gravatarHash
                existingUser.tmdbAvatarPath = user.tmdbAvatarPath
                existingUser.isGuest = user.isGuest
            } else {
                // Nếu chưa có User, thêm mới
                realm.add(user)
            }
        }
    }
    
    // MARK: - Tải User từ Realm
    private func loadCurrentUserFromRealm() -> UserModel? {
        return realm.objects(UserModel.self).first
    }
    
    // MARK: - Xóa User hiện tại (chỉ xóa user đầu tiên)
    func deleteCurrentUser() {
        try? realm.write {
            if let existingUser = realm.objects(UserModel.self).first {
                realm.delete(existingUser) // Xóa User đầu tiên tìm được
                self.user = nil
            }
        }
    }
    
    func saveSessionId(_ sessionId: String) {
        try? realm.write {
            if let existingUser = realm.objects(UserModel.self).first {
                existingUser.sessionID = sessionId // Update sessionId in Realm
                self.user = existingUser // Synchronize the in-memory user
            }
        }
    }
    
}

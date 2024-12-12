//
//  NetworkManager.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 14/11/24.
//


import Foundation
import Reachability

class NetworkManager {
    
    //MARK: - Properties
    static let shared = NetworkManager()
    private var reachability: Reachability?
    
    private init() {
        // Khởi tạo Reachability
        reachability = try? Reachability()
    }
    
    //MARK: - Methods
    func startMonitoring() {
        // Đăng ký thông báo khi có thay đổi trạng thái mạng
        reachability?.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Connected via WiFi")
            } else if reachability.connection == .cellular {
                print("Connected via Cellular")
            }
            NotificationCenter.default.post(name: .languageChanged, object: nil)
            NotificationCenter.default.post(name: .popWhenAddSuccess, object: nil)
            NotificationCenter.default.post(name: .fetchMyCollection, object: nil)

        }
        
        reachability?.whenUnreachable = { _ in
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start network notifier")
        }
    }
    
    func stopMonitoring() {
        reachability?.stopNotifier()
    }
    
    func isConnected() -> Bool {
        return reachability?.connection != .unavailable
    }
}

//
//  AppDelegate.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 21/9/24.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNetworkMonitoring()
        setupRealm()
        setupIQKeyboardManager()
        setupFirstLaunch()
        _ = SettingsManager.shared.currentLanguage
        SettingsManager.shared.setupAppearance()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "movieinminutes" {
            print("back")
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if AppConstant.isFromSafari {
            guard let requestToken = AppConstant.requestToken,
                  requestToken.isValid() else {
                return
            }
            UserModel.createSessionId(requestToken: requestToken.token) { [weak self] result, sessionID, message in
                if result {
                    UserModel.fetchAccountDetail(sessionID: sessionID) { [weak self] success, message in
                        guard let self = self else { return }
                        if success {
                            self.setRootToTabBar()
                        } else {
                            BaseAppController.showAlertInWindow(title: LanguageDictionary.pleaseLoginAgain.dictionary, message: message)
                        }
                    }
                } else {
                    BaseAppController.showAlertInWindow(title: LanguageDictionary.pleaseLoginAgain.dictionary, message: message)
                }
            }
            AppConstant.isFromSafari = false
        }
    }
    
    
    func setRootToTabBar() {
        // Hiển thị loading indicator
        if !AppConstant.isLoading {
            LoadingManager.shared.showLoadingIndicator()
            AppConstant.isLoading = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Lấy window đang hoạt động
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                print("No active window found")
                LoadingManager.shared.hideLoadingIndicator()
                AppConstant.isLoading = false
                return
            }
            
            // Tạo TabBarController
            let tabBarController = UIStoryboard(name: "MovieViewController", bundle: nil)
                .instantiateViewController(withIdentifier: "TabbarController")
            
            // Cập nhật rootViewController
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
            
            // Ẩn loading indicator sau khi chuyển đổi giao diện
            DispatchQueue.main.async {
                LoadingManager.shared.hideLoadingIndicator()
                AppConstant.isLoading = false
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NetworkManager.shared.stopMonitoring()
        
    }
    
    func setupNetworkMonitoring() {
        NetworkManager.shared.startMonitoring()
    }
    
    func setupIQKeyboardManager() {
        IQKeyboardToolbarManager.shared.isEnabled = true
        IQKeyboardManager.shared.isEnabled = true
    }
    
    func setupRealm() {
        _ = RealmManager.shared
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "cannot open fileURL")
    }
    
    func setupFirstLaunch() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let user = RealmManager.shared.currentUser {
            if !user.sessionID.isEmpty {
                UserModel.fetchAccountDetail(sessionID: user.sessionID) { [weak self] success, message in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if success {
                            self.window?.rootViewController = UIStoryboard(name: "MovieViewController", bundle: nil).instantiateViewController(withIdentifier: "TabbarController")
                            self.window?.makeKeyAndVisible()
                            return
                        } else {
                            BaseAppController.showAlertInWindow(title: "", message: message)
                        }
                    }
                }
            }
            self.window?.rootViewController = UIStoryboard(name: "MovieViewController", bundle: nil).instantiateViewController(withIdentifier: "TabbarController")
        } else {
            self.window?.rootViewController = UIStoryboard(name: "PersonalViewController", bundle: nil).instantiateViewController(withIdentifier: "NavPersonalViewController")
        }
        self.window?.makeKeyAndVisible()
    }
    
}


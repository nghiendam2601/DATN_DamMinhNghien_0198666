//
//  SettingsManager.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 20/11/24.
//

import Foundation
import UIKit


class SettingsManager {
    
    //MARK: - Properties
    static let shared = SettingsManager()
    private let languageKey = "selectedLanguage"
    private let appearanceKey = "selectedAppearance"
    
    // Ngôn ngữ hiện tại
    var currentLanguage: AppLanguage {
        get {
            if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
               let language = AppLanguage(rawValue: savedLanguage) {
                return language
            }
            // Lấy ngôn ngữ từ hệ thống
            let systemLanguage = Locale.preferredLanguages.first ?? "en"
            if systemLanguage == "vi-VN" {
                return AppLanguage.vietnamese
            } else {
                return AppLanguage.english
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: languageKey)
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    // Giao diện hiện tại
    var currentAppearance: AppAppearance {
        get {
            if let savedAppearance = UserDefaults.standard.string(forKey: appearanceKey),
               let appearance = AppAppearance(rawValue: savedAppearance) {
                return appearance
            }
            // Lấy giao diện từ hệ thống
            let systemStyle = UITraitCollection.current.userInterfaceStyle
            switch systemStyle {
            case .dark:
                return .dark
            default:
                return .light
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: appearanceKey)
            NotificationCenter.default.post(name: .appearanceChanged, object: nil)
        }
    }
    
    func setupAppearance() {
        if #available(iOS 13.0, *) {
            let style: UIUserInterfaceStyle = currentAppearance == .dark ? .dark : .light
            // Áp dụng giao diện cho tất cả Scene
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .forEach { windowScene in
                    windowScene.windows.forEach { window in
                        window.overrideUserInterfaceStyle = style
                    }
                }
        }
    }
    
}

enum AppLanguage: String {
    case english = "en"
    case vietnamese = "vi"
    
    var displayName: String {
        switch self {
        case .english:
            return LanguageDictionary.currentLanguage.dictionary
        case .vietnamese:
            return LanguageDictionary.currentLanguage.dictionary
        }
    }
}

enum AppAppearance: String {
    case light
    case dark
    
    var displayName: String {
        switch self {
        case .light:
            return LanguageDictionary.light.dictionary
        case .dark:
            return LanguageDictionary.dark.dictionary
        }
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("LanguageChanged")
    static let appearanceChanged = Notification.Name("AppearanceChanged")
    static let fetchMyCollection = Notification.Name("FetchMyCollection")
    static let popWhenAddSuccess = Notification.Name("PopWhenAddSuccess")
}



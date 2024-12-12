//
//  BaseAppController.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 19/11/24.
//

import Foundation
import UIKit

class BaseAppController {
    
    static func showAlertInWindow(title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                print("No key window found")
                return
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // If no actions are provided, add a default "OK" action
            if let actions = actions, !actions.isEmpty {
                actions.forEach { alertController.addAction($0) }
            } else {
                let defaultAction = UIAlertAction(title: LanguageDictionary.ok.dictionary, style: .default, handler: nil)
                alertController.addAction(defaultAction)
            }
            
            // Get the topmost view controller to present the alert
            var topController = window.rootViewController
            while let presentedViewController = topController?.presentedViewController {
                topController = presentedViewController
            }
            
            topController?.present(alertController, animated: true, completion: nil)
        }
    }
    
}

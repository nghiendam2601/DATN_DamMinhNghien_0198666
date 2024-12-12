//
//  LoadingManager.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 14/11/24.
//


import UIKit
import NVActivityIndicatorView

class LoadingManager {
    
    //MARK: - Properties
    static let shared = LoadingManager()
    private var dimmingView: UIView?
    private var activityIndicator: NVActivityIndicatorView?
    
    private init() {}
    
    //MARK: - Methods
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
            
            // Tạo dimming view nếu chưa tồn tại
            if self.dimmingView == nil {
                self.dimmingView = UIView(frame: window.bounds)
                self.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.dimmingView?.isUserInteractionEnabled = true
            }
            
            // Tạo activity indicator nếu chưa tồn tại
            if self.activityIndicator == nil {
                self.activityIndicator = NVActivityIndicatorView(
                    frame: CGRect(x: 0, y: 0, width: 50, height: 50),
                    type: .circleStrokeSpin,
                    color: .red,
                    padding: 10
                )
                self.activityIndicator?.center = window.center
            }
            
            // Thêm dimming view và activity indicator vào window
            if let dimmingView = self.dimmingView, let activityIndicator = self.activityIndicator {
                window.addSubview(dimmingView)
                window.addSubview(activityIndicator)
                activityIndicator.startAnimating()
            }
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            // Dừng animation và loại bỏ dimming view và activity indicator
            self.activityIndicator?.stopAnimating()
            self.dimmingView?.removeFromSuperview()
            self.activityIndicator?.removeFromSuperview()
        }
    }
    
}

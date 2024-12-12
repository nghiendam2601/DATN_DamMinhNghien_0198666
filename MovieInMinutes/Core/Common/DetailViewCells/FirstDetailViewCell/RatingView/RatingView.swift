//
//  RatingView.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 20/11/24.
//

import UIKit
import RatingStar

class RatingView: UIView {
    
    // MARK: - Properties
    var movieID: Int = 0
    var tvSeriesID: Int = 0
    var ratingStar: UIRatingStar?
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initComponents()
    }
    
}

// MARK: - Configure methods
extension RatingView {
    
    fileprivate func initComponents() {
        if let view = Bundle.main.loadNibNamed("RatingView", owner: self, options: nil)?.first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(named: "LabelApp")?.cgColor
            view.layer.cornerRadius = view.bounds.height / 7
            view.clipsToBounds = true
            ratingStar = UIRatingStar(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            if let ratingStar = ratingStar {
                ratingStar.selectionColor = .rating
                ratingStar.starColor = .background
                ratingStar.showNumbers = false
                view.addSubview(ratingStar)
                ratingStar.translatesAutoresizingMaskIntoConstraints = false // Sử dụng Auto Layout
                NSLayoutConstraint.activate([
                    ratingStar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    ratingStar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    ratingStar.widthAnchor.constraint(equalToConstant: 200),
                    ratingStar.heightAnchor.constraint(equalToConstant: 200)
                ])
            }
        }
    }
    
    func configure(with movieID: Int) {
        self.movieID = movieID
        if let view = self.subviews.first,
           let ratingStar = view.subviews.first(where: { $0 is UIRatingStar }) as? UIRatingStar,
           let rate = AppConstant.moviesRated[movieID] {
            ratingStar.value = Int(rate / 2) // Gán giá trị rating hiện tại
        }
    }
    
    func configureTV(with tvSeriesID: Int) {
        self.tvSeriesID = tvSeriesID
        if let view = self.subviews.first,
           let ratingStar = view.subviews.first(where: { $0 is UIRatingStar }) as? UIRatingStar,
           let rate = AppConstant.tvRated[tvSeriesID] {
            ratingStar.value = Int(rate / 2) // Gán giá trị rating hiện tại
        }
    }
    
    
}

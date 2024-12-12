//
//  ActorDetailTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 27/11/24.
//

import UIKit

class ActorDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imgBig: UIImageView!
    @IBOutlet weak var BigView: UIView!
    @IBOutlet weak var imgSmall: UIImageView!
    
    // MARK: - Properties
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(setupUI), name: .appearanceChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Data
    func setupData(actor: ActorModel?) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullImagePath = baseURL + (actor?.profilePath ?? "")
        imgSmall.layer.cornerRadius = 15
        imgSmall.clipsToBounds = true
        ImageLoader.loadImage(for: imgBig, from: fullImagePath, cornerRadius: 0)
        ImageLoader.loadImage(for: imgSmall, from: fullImagePath, cornerRadius: 0)
    }
    
    func setupData(season: DetailSeasonModel?) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullImagePath = baseURL + (season?.posterPath ?? "")
        imgSmall.layer.cornerRadius = 15
        imgSmall.clipsToBounds = true
        ImageLoader.loadImage(for: imgBig, from: fullImagePath, cornerRadius: 0)
        ImageLoader.loadImage(for: imgSmall, from: fullImagePath, cornerRadius: 0)
    }
    
    func setupData(episode: DetailEpisodeModel?) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullImagePath = baseURL + (episode?.stillPath ?? "")
        imgSmall.layer.cornerRadius = 15
        imgSmall.clipsToBounds = true
        ImageLoader.loadImage(for: imgBig, from: fullImagePath, cornerRadius: 0)
        ImageLoader.loadImage(for: imgSmall, from: fullImagePath, cornerRadius: 0)
    }
    
    // MARK: - UI Configuration
    @objc func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.configureBlurEffect()
            self?.addGradientLayer()
        }
    }
    
    private func configureBlurEffect() {
        blurEffectView.alpha = 1
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = imgBig.frame
        imgBig.addSubview(blurEffectView)
    }
    
    
    private func addGradientLayer() {
        gradientLayer?.removeFromSuperlayer()
        let color = SettingsManager.shared.currentAppearance == .dark ? UIColor.black : UIColor.white
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [
            UIColor.clear.cgColor,
            color.cgColor
        ]
        gradientLayer?.locations = [0.3, 1.0]
        gradientLayer?.frame = imgBig.frame
        imgBig.layer.addSublayer(self.gradientLayer!)
    }
    
    private func updateBlurEffectFrame() {
        blurEffectView.frame = imgBig.frame // Ensure blur effect fills the entire image view
    }
    
    private func updateGradientLayerFrame() {
        gradientLayer?.frame = imgBig.frame // Ensure gradient layer fills the entire image view
    }
}
